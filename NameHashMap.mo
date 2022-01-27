/**
 * Module     : NameHash.mo
 * Author     : ICLight.house Team
 * License    : GNU General Public License v3.0
 * Stability  : Experimental
 * Canister   : jchdi-raaaa-aaaak-aabzq-cai
 * Github     : https://github.com/iclighthouse/
 */
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Cycles "mo:base/ExperimentalCycles";
import NameHash "./lib/NameHash";

shared(installMsg) actor class NameHashMap() = this {
    private stable var owner: Principal = installMsg.caller;
    private stable var maps: Trie.Trie<Nat, [Text]> = Trie.empty(); 

    private func _onlyOwner(_caller: Principal) : Bool {
        return _caller == owner;
    };
    private func keyn(t: Nat) : Trie.Key<Nat> { return { key = t; hash = Hash.hash(t) }; };
    private func _addName(_name: Text, _names: [Text]) : [Text]{
        switch(Array.find(_names, func (t:Text):Bool{ if (t == _name) true else false })){
            case(null){ return Array.append(_names, [_name]);};
            case(_){ return _names; };
        };
    };

    public query func fromHash(_hash: Nat) : async [Text]{  
        switch(Trie.get(maps, keyn(_hash), Nat.equal)){
            case(?(name)){ return name;};
            case(_){ return []; };
        };
    };
    public query func fromHashs(_hashs: [Nat]) : async [[Text]]{  
        let _names = Array.init<[Text]>(_hashs.size(), []);
        for (i in _hashs.keys()){
            switch(Trie.get(maps, keyn(_hashs[i]), Nat.equal)){
                case(?(name)){_names[i] := name;};
                case(_){};
            };
        };
        return Array.freeze(_names);
    };
    public func fromName(_name: Text) : async Nat{ 
        let _hash = NameHash.hash(_name); 
        maps := Trie.put(maps, keyn(_hash), Nat.equal, [_name]).0;
        return _hash;
    };
    public func fromNames(_names: [Text]) : async [Nat]{
        assert(_names.size() <= 256);
        let _hashs = Array.init<Nat>(_names.size(), 0); 
        for (i in _names.keys()){
            _hashs[i] := NameHash.hash(_names[i]); 
            let tempNames = Option.get(Trie.get(maps, keyn(_hashs[i]), Nat.equal), []);
            maps := Trie.put(maps, keyn(_hashs[i]), Nat.equal, _addName(_names[i], tempNames)).0;
        };
        return Array.freeze(_hashs);
    };

    /* 
    * Owner's Management
    */
    public query func getOwner() : async Principal{  
        return owner;
    };
    public shared(msg) func changeOwner(_newOwner: Principal) : async Bool{  
        assert(_onlyOwner(msg.caller));
        owner := _newOwner;
        return true;
    };
    // // set nameHash map
    // public shared(msg) func setNameHash(_names: [Text], _hashs: [Nat]) : async Bool{  
    //     assert(_onlyOwner(msg.caller));
    //     assert(_names.size() == _hashs.size());
    //     for (i in _names.keys()){
    //         let tempNames = Option.get(Trie.get(maps, keyn(_hashs[i]), Nat.equal), []);
    //         maps := Trie.put(maps, keyn(_hashs[i]), Nat.equal, _addName(_names[i], tempNames)).0;
    //     };
    //     return true;
    // };
    // receive cycles
    public func wallet_receive(): async (){
        let amout = Cycles.available();
        let accepted = Cycles.accept(amout);
    };

};