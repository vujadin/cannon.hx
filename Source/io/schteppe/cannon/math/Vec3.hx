package io.schteppe.cannon.math;

/**
 * @class Vec3
 * @brief 3-dimensional vector
 * @param float x
 * @param float y
 * @param float z
 * @author schteppe
 */
class Vec3 {

    public var x:Float;
    public var y:Float;
    public var z:Float;

    static var Vec3_tangents_n:Vec3 = new Vec3();
    static var Vec3_tangents_randVec:Vec3 = new Vec3();

    public function new(x:Float = 0.0, y:Float = 0.0, z:Float = 0.0){
        /**
        * @property float x
        * @memberof Vec3
        */
        this.x = x;
        /**
        * @property float y
        * @memberof Vec3
        */
        this.y = y;
        /**
        * @property float z
        * @memberof Vec3
        */
        this.z = z;
    }

    /**
     * @method cross
     * @memberof Vec3
     * @brief Vector cross product
     * @param Vec3 v
     * @param Vec3 target Optional. Target to save in.
     * @return Vec3
     */
    public function cross(v:Vec3,target:Vec3 = null):Vec3{
        var vx:Float = v.x; var vy:Float = v.y; var vz:Float = v.z; var x:Float = this.x; var y:Float = this.y; var z:Float = this.z;
        if (target == null) target = new Vec3();

        target.x = (y * vz) - (z * vy);
        target.y = (z * vx) - (x * vz);
        target.z = (x * vy) - (y * vx);

        return target;
    }

    /**
     * @method set
     * @memberof Vec3
     * @brief Set the vectors' 3 elements
     * @param float x
     * @param float y
     * @param float z
     * @return Vec3
     */
    public function set(x,y,z):Vec3{
        this.x = x;
        this.y = y;
        this.z = z;
        return this;
    }

    /**
     * @method vadd
     * @memberof Vec3
     * @brief Vector addition
     * @param Vec3 v
     * @param Vec3 target Optional.
     * @return Vec3
     */
    public function vadd(v:Vec3,target:Vec3 = null):Vec3 {
        if(target != null){
            target.x = v.x + this.x;
            target.y = v.y + this.y;
            target.z = v.z + this.z;
            return target;
        } else {
            return new Vec3(this.x + v.x,
                            this.y + v.y,
                            this.z + v.z);
        }
    }

    /**
     * @method vsub
     * @memberof Vec3
     * @brief Vector subtraction
     * @param Vec3 v
     * @param Vec3 target Optional. Target to save in.
     * @return Vec3
     */
    public function vsub(v:Vec3,target:Vec3 = null):Vec3 {
        if(target != null){
            target.x = this.x - v.x;
            target.y = this.y - v.y;
            target.z = this.z - v.z;
            return target;
        } else {
            return new Vec3(this.x-v.x,
                            this.y-v.y,
                            this.z-v.z);
        }
    }

    /**
     * @method crossmat
     * @memberof Vec3
     * @brief Get the cross product matrix a_cross from a vector, such that a x b = a_cross * b = c
     * @see http://www8.cs.umu.se/kurser/TDBD24/VT06/lectures/Lecture6.pdf
     * @return CANNON.Mat3
     */
    public function crossmat():Void {
        // FIXME 
        //return new CANNON.Mat3([     0,  -this.z,   this.y,
        //                        this.z,        0,  -this.x,
        //                       -this.y,   this.x,        0]);
    }

    /**
     * @method normalize
     * @memberof Vec3
     * @brief Normalize the vector. Note that this changes the values in the vector.
     * @return float Returns the norm of the vector
     */
    public function normalize():Float{
        var x:Float = this.x; var y:Float = this.y; var z:Float = this.z;
        var n:Float = Math.sqrt(x*x + y*y + z*z);
        if(n>0.0){
            var invN:Float = 1/n;
            this.x *= invN;
            this.y *= invN;
            this.z *= invN;
        } else {
            // Make something up
            this.x = 0;
            this.y = 0;
            this.z = 0;
        }
        return n;
    }

    /**
     * @method unit
     * @memberof Vec3
     * @brief Get the version of this vector that is of length 1.
     * @param Vec3 target Optional target to save in
     * @return Vec3 Returns the unit vector
     */
    public function unit(target):Vec3{
        if (target == null) target = new Vec3();
        var x:Float = this.x; var y:Float = this.y; var z:Float = this.z;
        var ninv:Float = Math.sqrt(x*x + y*y + z*z);
        if(ninv>0.0){
            ninv = 1.0/ninv;
            target.x = x * ninv;
            target.y = y * ninv;
            target.z = z * ninv;
        } else {
            target.x = 1;
            target.y = 0;
            target.z = 0;
        }
        return target;
    }

    /**
     * @method norm
     * @memberof Vec3
     * @brief Get the 2-norm (length) of the vector
     * @return float
     */
    public function norm():Float{
        var x:Float = this.x; var y:Float = this.y; var z:Float = this.z;
        return Math.sqrt(x*x + y*y + z*z);
    }

    /**
     * @method norm2
     * @memberof Vec3
     * @brief Get the squared length of the vector
     * @return float
     */
    public function norm2():Float{
        return this.dot(this);
    }

    public function distanceTo(p):Float{
        var x:Float = this.x; var y:Float = this.y; var z:Float = this.z;
        var px:Float = p.x; var py:Float = p.y; var pz:Float = p.z;
        return Math.sqrt((px-x)*(px-x)+
                         (py-y)*(py-y)+
                         (pz-z)*(pz-z));
    }

    /**
     * @method mult
     * @memberof Vec3
     * @brief Multiply the vector with a scalar
     * @param float scalar
     * @param Vec3 target
     * @return Vec3
     */
    public function mult(scalar:Float,target:Vec3 = null):Vec3{
        if (target == null) target = new Vec3();
        var x:Float = this.x;
        var y:Float = this.y;
        var z:Float = this.z;
        target.x = scalar * x;
        target.y = scalar * y;
        target.z = scalar * z;
        return target;
    }

    /**
     * @method dot
     * @memberof Vec3
     * @brief Calculate dot product
     * @param Vec3 v
     * @return float
     */
    public function dot(v:Vec3):Float{
        return this.x * v.x + this.y * v.y + this.z * v.z;
    }

    /**
     * @method isZero
     * @memberof Vec3
     * @return bool
     */
    public function isZero():Bool{
        return this.x==0 && this.y==0 && this.z==0;
    }

    /**
     * @method negate
     * @memberof Vec3
     * @brief Make the vector point in the opposite direction.
     * @param Vec3 target Optional target to save in
     * @return Vec3
     */
    public function negate(target:Vec3 = null):Vec3{
        if (target == null) target = new Vec3();
        target.x = -this.x;
        target.y = -this.y;
        target.z = -this.z;
        return target;
    }

    /**
     * @method tangents
     * @memberof Vec3
     * @brief Compute two artificial tangents to the vector
     * @param Vec3 t1 Vector object to save the first tangent in
     * @param Vec3 t2 Vector object to save the second tangent in
     */
    public function tangents(t1:Vec3,t2:Vec3){
        var norm:Float = this.norm();
        if(norm>0.0){
            var n = Vec3_tangents_n;
            var inorm:Float = 1/norm;
            n.set(this.x*inorm,this.y*inorm,this.z*inorm);
            var randVec = Vec3_tangents_randVec;
            if(Math.abs(n.x) < 0.9){
                randVec.set(1,0,0);
                n.cross(randVec,t1);
            } else {
                randVec.set(0,1,0);
                n.cross(randVec,t1);
            }
            n.cross(t1,t2);
        } else {
            // The normal length is zero, make something up
            t1.set(1,0,0).normalize();
            t2.set(0,1,0).normalize();
        }
    }

    /**
     * @method toString
     * @memberof Vec3
     * @brief Converts to a more readable format
     * @return string
     */
    public function toString():String{
        return this.x+","+this.y+","+this.z;
    }

    /**
     * @method copy
     * @memberof Vec3
     * @brief Copy the vector.
     * @param Vec3 target
     * @return Vec3
     */
    public function copy(target:Vec3):Vec3{
        if (target == null) target = new Vec3();
        target.x = this.x;
        target.y = this.y;
        target.z = this.z;
        return target;
    }


    /**
     * @method lerp
     * @memberof Vec3
     * @brief Do a linear interpolation between two vectors
     * @param Vec3 v
     * @param float t A number between 0 and 1. 0 will make this function return u, and 1 will make it return v. Numbers in between will generate a vector in between them.
     * @param Vec3 target
     */
    public function lerp(v:Vec3,t:Float,target:Vec3):Void{
        var x:Float = this.x; var y:Float = this.y; var z:Float = this.z;
        target.x = x + (v.x-x)*t;
        target.y = y + (v.y-y)*t;
        target.z = z + (v.z-z)*t;
    }

    /**
     * @method almostEquals
     * @memberof Vec3
     * @brief Check if a vector equals is almost equal to another one.
     * @param Vec3 v
     * @param float precision
     * @return bool
     */
    public function almostEquals(v:Vec3,precision:Float = -1.0):Bool{
        if(precision < -0.99){
            precision = 1e-6;
        }
        if( Math.abs(this.x-v.x)>precision ||
            Math.abs(this.y-v.y)>precision ||
            Math.abs(this.z-v.z)>precision){
            return false;
        }
        return true;
    }

    /**
     * @method almostZero
     * @brief Check if a vector is almost zero
     * @param float precision
     * @memberof Vec3
     */
    public function almostZero(v:Vec3):Bool {
        var precision:Float = 1e-6; 
        if( Math.abs(this.x)>precision ||
            Math.abs(this.y)>precision ||
            Math.abs(this.z)>precision){
            return false;
        }
        return true;
    }
}
