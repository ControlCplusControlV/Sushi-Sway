use fuel_tx::Salt;
use fuels_abigen_macro::abigen;
use fuels_rs::contract::Contract;
use rand::rngs::StdRng;
use rand::{Rng, SeedableRng};

abigen!(MyContract, "./BentoBoxABI.json");

pub struct DepositInput {
    input_token:[u8; 32],
    from:[u8; 32],
    to:[u8; 32],
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

    let inputToken_input:[u8; 32] = [0; 32];
    
    let from_input:[u8; 32] = [5; 32];

    let to_input:[u8; 32] = [7; 32];

    let inputStruct = mycontract_mod::DepositInput {
        input_token: inputToken_input,
        from:from_input, 
        to: to_input,
    };

    // Call `initialize_counter()` method in our deployed contract.
    // Note that, here, you get type-safety for free!
    let _result = contract_instance
        .deposit(1000000, 100, [0; 32], inputStruct)
        .call()
        .await
        .unwrap();

}
