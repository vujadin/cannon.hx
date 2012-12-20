/**
 * @class CANNON.ContactConstraint
 * @brief Contact constraint class
 * @author schteppe
 * @param CANNON.RigidBody bodyA
 * @param CANNON.RigidBody bodyB
 * @param float friction
 * @extends CANNON.Constraint
 * @todo integrate with the World class
 */
CANNON.ContactConstraint = function(bi,bj){
    CANNON.Constraint.call(this);
    this.penetration = 0.0;
    this.bi = bi;
    this.bj = bj;
    this.slipForce = 0.0;
    this.ri = new CANNON.Vec3();
    this.penetrationVec = new CANNON.Vec3();
    this.rj = new CANNON.Vec3();
    this.ni = new CANNON.Vec3();
    this.rixn = new CANNON.Vec3();
    this.rjxn = new CANNON.Vec3();
    this.rixw = new CANNON.Vec3();
    this.rjxw = new CANNON.Vec3();

    this.invIi = new CANNON.Mat3();
    this.invIj = new CANNON.Mat3();

    this.minForce = 0.0; // Force must be repelling
    this.maxForce = 1e6;

    this.relVel = new CANNON.Vec3();
    this.relForce = new CANNON.Vec3();
};

CANNON.ContactConstraint.prototype = new CANNON.Constraint();
CANNON.ContactConstraint.prototype.constructor = CANNON.ContactConstraint;

CANNON.ContactConstraint.prototype.computeB = function(a,b,h){
    var bi = this.bi;
    var bj = this.bj;
    var ri = this.ri;
    var rj = this.rj;
    var rixn = this.rixn;
    var rjxn = this.rjxn;

    var vi = bi.velocity;
    var wi = bi.angularVelocity;
    var fi = bi.force;
    var taui = bi.tau;

    var vj = bj.velocity;
    var wj = bj.angularVelocity;
    var fj = bj.force;
    var tauj = bj.tau;

    var relVel = this.relVel;
    var relForce = this.relForce;
    var penetrationVec = this.penetrationVec;
    var invMassi = bi.invMass;
    var invMassj = bj.invMass;

    var invIi = this.invIi;
    var invIj = this.invIj;

    invIi.setTrace(bi.invInertia);
    invIj.setTrace(bj.invInertia);

    var n = this.ni;

    // Caluclate cross products
    ri.cross(n,rixn);
    rj.cross(n,rjxn);

    // Calculate q = xj+rj -(xi+ri) i.e. the penetration vector
    var penetrationVec = this.penetrationVec;
    penetrationVec.set(0,0,0);
    penetrationVec.vadd(bj.position,penetrationVec);
    penetrationVec.vadd(rj,penetrationVec);
    penetrationVec.vsub(bi.position,penetrationVec);
    penetrationVec.vsub(ri,penetrationVec);

    var Gq = n.dot(penetrationVec);//-Math.abs(this.penetration);

    // Compute iteration
    var GW = vj.dot(n) - vi.dot(n) + wj.dot(rjxn) - wi.dot(rixn);
    var GiMf = fj.dot(n)*invMassj - fi.dot(n)*invMassi + rjxn.dot(invIj.vmult(tauj)) - rixn.dot(invIi.vmult(taui)) ;

    var B = - Gq * a - GW * b - h*GiMf;

    return B;
};

// Compute C = GMG+eps
CANNON.ContactConstraint.prototype.computeC = function(eps){
    var bi = this.bi;
    var bj = this.bj;
    var rixn = this.rixn;
    var rjxn = this.rjxn;
    var invMassi = bi.invMass;
    var invMassj = bj.invMass;

    var C = invMassi + invMassj + eps;

    var invIi = this.invIi;
    var invIj = this.invIj;

    invIi.setTrace(bi.invInertia);
    invIj.setTrace(bj.invInertia);

    // Compute rxn * I * rxn for each body
    C += invIi.vmult(rixn).dot(rixn);
    C += invIj.vmult(rjxn).dot(rjxn);


    return C;
};

CANNON.ContactConstraint.prototype.computeGWlambda = function(){
    var bi = this.bi;
    var bj = this.bj;

    var GWlambda = 0.0;
    var ulambda = bj.vlambda.vsub(bi.vlambda);
    GWlambda += ulambda.dot(this.ni);

    // Angular
    GWlambda -= bi.wlambda.dot(this.rixn);
    GWlambda += bj.wlambda.dot(this.rjxn);

    return GWlambda;
};

CANNON.ContactConstraint.prototype.addToWlambda = function(deltalambda){
    var bi = this.bi;
    var bj = this.bj;
    var rixn = this.rixn;
    var rjxn = this.rjxn;
    var invMassi = bi.invMass;
    var invMassj = bj.invMass;
    var n = this.ni;

    // Add to linear velocity
    bi.vlambda.vsub(n.mult(invMassi * deltalambda),bi.vlambda);
    bj.vlambda.vadd(n.mult(invMassj * deltalambda),bj.vlambda);

    // Add to angular velocity
    if(bi.wlambda){
        var I = this.invIi;
        bi.wlambda.vsub(I.vmult(rixn).mult(deltalambda),bi.wlambda);
    }
    if(bj.wlambda){
        var I = this.invIj;
        bj.wlambda.vadd(I.vmult(rjxn).mult(deltalambda),bj.wlambda);
    }
};