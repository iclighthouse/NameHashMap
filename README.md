# NameHashMap

NameHashMap is a mapping table of the name and hash of candid canister.

## Getting started

**Notes**  
- Querying hash by name will save the name-hash map in the canister.
- Querying name by hash does not necessarily return valid result, depending on whether someone has queried the hash by name.

**Name to Hash**
```
dfx canister --network ic call jchdi-raaaa-aaaak-aabzq-cai fromName '("abc")'
```
returns:
```
(4_845_666 : nat)
```

**Names to Hashs (batch)**
```
dfx canister --network ic call jchdi-raaaa-aaaak-aabzq-cai fromNames '(vec {"abc"; "def"})'
```
returns:
```
(vec { 4_845_666 : nat; 4_995_525 : nat })
```

**Hash to Name**
```
dfx canister --network ic call jchdi-raaaa-aaaak-aabzq-cai fromHash '(4_845_666:nat)'
```
returns:
```
(vec { "abc" })
```

**Hashs to Names (batch)**
```
dfx canister --network ic call jchdi-raaaa-aaaak-aabzq-cai fromHashs '(vec {4_845_666:nat; 4_995_525:nat})'
```
returns:
```
(vec { vec { "abc" }; vec { "def" } })
```
