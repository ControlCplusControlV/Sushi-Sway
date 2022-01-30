use fuel_tx::Salt;
use fuels_abigen_macro::abigen;
use fuels_rs::contract::Contract;
use rand::rngs::StdRng;
use rand::{Rng, SeedableRng};

abigen!(MyContract, "./BentoBoxABI.json");

pub struct BalanceOfInput {
    asset_id: [u8; 32], 
    address: [u8; 32],
}

#[tokio::test]
async fn harness() {
    let rng = &mut StdRng::seed_from_u64(2322u64);

    // Build the contract
    let salt: [u8; 32] = rng.gen();
    let salt = Salt::from(salt);
    let compiled = Contract::compile_sway_contract("./", salt).unwrap();

    // Launch a local network and deploy the contract
    let (client, _contract_id) = Contract::launch_and_deploy(&compiled).await.unwrap();

    let contract_instance = MyContract::new(compiled, client);

    let input_token_input:[u8; 32] = [0; 32];
    
    let from_input:[u8; 32] = [5; 32];

    let to_input:[u8; 32] = [7; 32];

    let input_struct = mycontract_mod::DepositInput {
        input_token: input_token_input,
        from: from_input, 
        to: to_input,
        amount: 10000000000,
        asset_id: [0; 32]
    };

    // Call `initialize_counter()` method in our deployed contract.
    // Note that, here, you get type-safety for free!
    let result2 = contract_instance
        .deposit(input_struct)
        .call()
        .await
        .unwrap();
    
    println!("{}", result2);

    let balance_of_check = mycontract_mod::BalanceOfInput {
        address: to_input,
        asset_id: [0; 32]
    };


    let result = contract_instance
        .balance_of(balance_of_check)
        .call()
        .await
        .unwrap();

    println!("{}", result);
}
