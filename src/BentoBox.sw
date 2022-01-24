contract;

// Needed for Hash Mappings
use std::chain::*;
use std::hash::*;
use std::storage::*;

/* --------------- Rebase Handling --------------- */

pub struct Rebase {
    elastic:u64,
    base:u64,
}

fn to_base(total:Rebase, elastic:u64, roundUp:bool) -> u64 {
    let mut base:u64 = 0;

    if(total.elastic == 0){
        base = elastic;
    } else {
        base = (elastic * total.base) / total.elastic;
        if (roundUp && (base * total.elastic) / total.base < elastic) {
            base = base + 1;
        };
    }; 

    base
}


fn to_elastic(total:Rebase, base:u64, roundUp:bool) -> u64 {
    let mut elastic:u64 = 0;

    if(total.elastic == 0){
        elastic = base;
    } else {
        elastic = (base * total.elastic) / total.base;
        
        if (roundUp && (elastic * total.base) / total.elastic < base) {
            elastic = elastic + 1;
        };
    };

    elastic
}

fn add(total:Rebase, elastic:u64, base:u64) -> Rebase {
    total.elastic = total.elastic + elastic;
    total.base = total.base + base;

    total
}

fn sub(total:Rebase, elastic:u64, base:u64) -> Rebase {
    total.elastic = total.elastic - elastic;
    total.base = total.base - base;

    total
}

/* ---------------- Important to note that these methods are different than Boring Solidity ----------- */
// Storage is iffy so this just returns a new rebase every time, Functional Programming remains supreme

fn add_elastic(total:Rebase, elastic:u64) -> Rebase {
    total.elastic = total.elastic + elastic;

    total
}

fn sub_elastic(total:Rebase, elastic:u64) -> Rebase {
    total.elastic = total.elastic - elastic;

    total
}

/* ---------------- Mapping Functions ----------------------- */

pub trait PairMapping {
	fn store(self, key1:b256, key2: b256, value:u64);
	fn retrieve(self, key1:b256, key2: b256) -> u64;
}

pub trait BalanceMapping {
	fn store_bal(self, key1:b256, value:Rebase);
	fn retrieve_bal(self, key1:b256) -> Rebase;
}

// Key (b256, b256) which is address -> (address -> u64)

pub struct BytesMapping{
	map_id : b256
}

impl PairMapping for BytesMapping {
    fn store(self, key1:b256, key2: b256, value:u64) {
        let storage_slot = hash_pair(key1, key2, HashMethod::Sha256);

        store(storage_slot, value);

    }

    fn retrieve(self, key1: b256, key2: b256) -> u64 {
        let storage_slot = hash_pair(key1, key2, HashMethod::Sha256);


        let resultingValue = get::<u64>(storage_slot);



        resultingValue
    }
}

impl BalanceMapping for BytesMapping {

    fn store_bal(self, key1:b256, value:Rebase) {
        let storage_slot = hash_pair(key1, self.map_id, HashMethod::Sha256);
        // Cursed way to store a struct, I am converting the storage slot to a uint
        // incrementing it, then casting back to a byte array
        let mut slotNumber:b256 = storage_slot;
        let mut storage_slot2:b256 = 0x0000000000000000000000000000000000000000000000000000000000000000;
        let shiftvalue:u64 = 1;
        storage_slot2 = asm(s1: slotNumber,s2:storage_slot2, s3:shiftvalue) {
            sll s2 s1 s3;
            
            s2:b256
        };

        store(storage_slot, value.elastic);
        store(storage_slot2, value.base);

    }

    fn retrieve_bal(self, key1:b256) -> Rebase {
        let storage_slot = hash_pair(key1, self.map_id, HashMethod::Sha256);
        // Cursed way to store a struct, I am converting the storage slot to a uint
        // incrementing it, then casting back to a byte array
        let mut slotNumber:b256 = storage_slot;
        let mut storage_slot2:b256 = 0x0000000000000000000000000000000000000000000000000000000000000000;
        let shiftvalue:u64 = 1;
        storage_slot2 = asm(s1: slotNumber,s2:storage_slot2, s3:shiftvalue) {
            sll s2 s1 s3;
            
            s2:b256
        };



        let resultingElastic = get::<u64>(storage_slot);
        let resultingBase = get::<u64>(storage_slot2);

        let resultingValue:Rebase = Rebase{
            elastic: resultingElastic,
            base: resultingBase,
        };    


        resultingValue
    }
}

pub struct DepositInput {
    input_token:b256,
    from:b256,
    to:b256,
}

pub struct TransferInput {
    token:b256,
    from:b256,
    to:b256,
    share:u64,
}

abi map_test {
    fn deposit(gas: u64, coins: u64, asset_id: b256, input: DepositInput) -> u64;
fn balance_of(gas: u64, coins: u64, asset_id: b256, input: b256) -> u64;
}

impl map_test for Contract {

    fn deposit(gas: u64, coins: u64, asset_id: b256, input: DepositInput) -> u64 {

        let totals = BytesMapping{
            map_id:0x5500000000000500000000005000000000000000000055000000000000000000
        };

        let mut total:Rebase = totals.retrieve_bal(asset_id);

        let share:u64 = to_base(total, coins, false);

        let balanceOf = BytesMapping{
            map_id:0x5500000006000500000000055000060000500006000055000000000006000000
        };

        let startingBal:u64 = balanceOf.retrieve(asset_id, input.to);
        let updatedBal:u64 = startingBal + share;
        balanceOf.store(asset_id, input.to, updatedBal);

        total.base = total.base + share;
        total.elastic = total.elastic + coins;

        totals.store_bal(asset_id, total);

        share
    }

    fn balance_of(gas: u64, coins: u64, asset_id: b256, input: b256) -> u64 {
        let balanceOf = BytesMapping{
            map_id:0x5500000006000500000000055000060000500006000055000000000006000000
        };

        let returned_bal = balanceOf.retrieve(asset_id, input);

        returned_bal
    }

}