/**
 * Module     : NameHash.mo
 * Author     : ICLight.house Team
 * License    : Apache License 2.0
 * Stability  : Experimental
 */
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import Nat8 "mo:base/Nat8";
// int candid_text_hash(String text) { 
//     // hash(id) = ( Sum_(i=0..k) utf8(id)[i] * 223^(k-i) ) mod 2^32 where k = |utf8(id)|-1
//     int hash = 0;
//     for (int b in utf8.encode(text)) {
//         hash = (((hash * 223) % pow(2, 32) as int) + b) % pow(2, 32) as int;  
//     }
//     return hash as int;
// }

module{
    public func hash(name: Text) : Nat{
        let a = Blob.toArray(Text.encodeUtf8(name));
        var hash_: Nat = 0;
        for (b in a.vals()){
            hash_ := (((hash_ * 223) % (2 ** 32)) + Nat8.toNat(b)) % (2 ** 32);
        };
        hash_;
    };
};