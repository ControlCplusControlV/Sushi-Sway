contract;

use CopiedSway::*;
use std::chain::assert;

// Will be pushing to std lib later
pub struct address {
    value: b256,
}

pub struct depositInput {
    from: address,
    to: address,
}

pub struct depositOutput {
    amountOut:u64,
    shareOut:u64,
}

/* -------------- Some Mapping Definitions for Custom Implemented Mappings, Fix later with std lib ------------- */
// Needed Mappings [b256 -> b256 -> Rebase] and [b256 -> Rebase]

pub struct Mapping {
    name:b256
}

pub trait b256Mapping {
    fn store(self, key: b256, value: Rebase);
    fn retrieve(self, key: b256) -> Rebase;

}

// b256 -> Rebase
impl b256Mapping for Mapping {
    fn store(self, key: b256, value:b256) {
        let storage_slot = hash_pair(self.name, key, HashMethod::Sha256);
        
        store(storage_slot, value);

    }

    fn retrieve(self, key: b256) -> Rebase {
        let storage_slot = hash_pair(self.name, key, HashMethod::Sha256);

        let resultingValue:Rebase = get::<Rebase>(storage_slot);

        resultingValue
    }
}
// b256 -> b256 -> Rebase
pub struct Mapping {
    name:b256
}

pub trait b256Mapping {
    fn store(self, key: b256, value: Rebase);
    fn retrieve(self, key: b256) -> Mapping;

}

impl MappingMapping for Mapping {
    fn storeMap(self, key: b256, value:Mapping) {
        let storage_slot = hash_pair(self.name, key, HashMethod::Sha256);
        
        store(storage_slot, value);

    }

    fn retrieveMap(self, key: b256) -> Mapping {
        let storage_slot = hash_pair(self.name, key, HashMethod::Sha256);

        let resultingValue:Mapping = get::<Mapping>(storage_slot);

        resultingValue
    }
}


abi BentoBoxABI {
    fn deposit(gas: u64, coins: u64, asset_id: b256, inputData: depositInput) -> depositOutput;
}

// @TODO don't forget to implement allowed modifier
// @TODO Withdraw function
// @TODO Mappings
// @TODO Transfer
// @TODO Flashloans
// @TODO Strategies?
// @TODO The entire master contract thing

impl BentoBoxABI for BentoBox {
    let FLASH_LOAN_FEE :u64 = 50;
    let FLASH_LOAN_FEE_PRECISION:u64 = 100000; // 1e5
    let STRATEGY_DELAY:u64 = 0; // Change to 2 weeks however tf you do that
    let MAX_TARGET_PERCENTAGE:u64 = 95;
    let MINIMUM_SHARE_BALANCE:u64 1000;

    fn _tokenBalanceOf(asset_id: b256) -> u64 {
        let contractBal:u64 = this_balance(asset_id);
        let strategyBal:u64 = 0; // Implement Strategies later
    }

    fn deposit(gas: u64, coins: u64, asset_id: b256, inputData: depositInput) -> depositOutput {
        let zeroAddress:b256;
        assert(depositInput.to != zeroAddress); // To avoid a bad UI from burning funds

        // Fix this whenever mappings work
        let total:Rebase = totals[asset_id];
        assert(total.elastic != 0 || coins != 0); // Check token has non zero supply by ensuring some were sent to the Box 


        // Flow is different here because we always convert to share

        let share:u64 = total.toBase(amount, false);

        // Ignore deposit if below minimum Share balance
        // @TODO implement this

        // Fix all this , but here as a placeholder
        let balanceOf:Mapping = Mapping {
            name: 0x0000000000000000000000000000000000000000000000000000000000000000;
        }

        balanceOf.store()

        balanceOf[token][to] = balanceOf[token][to].add(share); // b256 -> b256 -> Rebase
        total.base = total.base.add(share.to128());
        total.elastic = total.elastic.add(amount.to128());
        totals[token] = total; // b256 -> Rebase

        let mut returnValue:depositOutput;
        returnValue.amountOut = coins;
        returnValue.shareOut = share;

        returnValue
    }


}
