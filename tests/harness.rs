use fuel_tx::ContractId;
use fuels::prelude::*;
use fuels::test_helpers;
use fuels_abigen_macro::abigen;

// Load abi from json
abigen!(MyContract, "out/debug/BentoBox.json");

async fn get_contract_instance() -> (MyContract, ContractId) {
    // Deploy the compiled contract
    let compiled = Contract::load_sway_contract("./out/debug/BentoBox.bin").unwrap();

    // Launch a local network and deploy the contract
    let (provider, wallet) = test_helpers::setup_test_provider_and_wallet().await;

    let id = Contract::deploy(&compiled, &provider, &wallet, TxParameters::default())
        .await
        .unwrap();

    let instance = MyContract::new(id.to_string(), provider, wallet);

    (instance, id)
}

#[tokio::test]
async fn test_deposit() {
    let (contract_instance, _id) = get_contract_instance().await;

    let input_token_input: [u8; 32] = [0; 32];

    let from_input: [u8; 32] = [5; 32];

    let to_input: [u8; 32] = [7; 32];

    let input_struct = mycontract_mod::DepositInput {
        from: from_input,
        to: to_input,
        amount: 10000000000,
        asset_id: [0; 32],
    };

    // Call `initialize_counter()` method in our deployed contract.
    // Note that, here, you get type-safety for free!
    let result = contract_instance
        .deposit(input_struct)
        .call()
        .await
        .unwrap();

    assert!(result > 1);
    // Now you have an instance of your contract you can use to test each function
}

#[tokio::test]
async fn test_withdraw() {
    let (contract_instance, _id) = get_contract_instance().await;

    let input_token_input: [u8; 32] = [0; 32];

    let from_input: [u8; 32] = [5; 32];

    let to_input: [u8; 32] = [7; 32];

    let input_struct = mycontract_mod::DepositInput {
        from: from_input,
        to: to_input,
        amount: 10000000000,
        asset_id: [0; 32],
    };

    // Call `initialize_counter()` method in our deployed contract.
    // Note that, here, you get type-safety for free!
    let _result2 = contract_instance
        .deposit(input_struct)
        .call()
        .await
        .unwrap();

    let balance_of_check = mycontract_mod::BalanceOfInput {
        address: to_input,
        asset_id: [0; 32],
        salt: 10,
    };

    let result = contract_instance
        .balance_of(balance_of_check)
        .call()
        .await
        .unwrap();

    assert!(result > 1);
}

#[tokio::test]
async fn test_transfer() {
    let (contract_instance, _id) = get_contract_instance().await;

    let input_token_input: [u8; 32] = [0; 32];

    let from_input: [u8; 32] = [5; 32];

    let to_input: [u8; 32] = [7; 32];

    let input_struct = mycontract_mod::DepositInput {
        from: from_input,
        to: to_input,
        amount: 10000000000,
        asset_id: [0; 32],
    };

    // Call `initialize_counter()` method in our deployed contract.
    // Note that, here, you get type-safety for free!
    let _result2 = contract_instance
        .deposit(input_struct)
        .call()
        .await
        .unwrap();

    let balance_of_check = mycontract_mod::BalanceOfInput {
        address: [10; 32],
        asset_id: [0; 32],
        salt: 1,
    };

    let transfer_check = mycontract_mod::TransferInput {
        from: to_input, // address money was deposited to
        to: [10; 32],
        share: 100,
        asset_id: [0; 32],
    };

    let balance_of_check2 = mycontract_mod::BalanceOfInput {
        address: [10; 32],
        asset_id: [0; 32],
        salt: 2,
    };

    let result3 = contract_instance
        .transfer(transfer_check)
        .call()
        .await
        .unwrap();

    let result = contract_instance
        .balance_of(balance_of_check)
        .call()
        .await
        .unwrap();

    assert!(result > 1);
}

#[tokio::test]
async fn test_balanceOf() {
    (contract_instance, _id) = get_contract_instance().await;

    let input_token_input: [u8; 32] = [0; 32];

    let from_input: [u8; 32] = [5; 32];

    let to_input: [u8; 32] = [7; 32];

    let input_struct = mycontract_mod::DepositInput {
        from: from_input,
        to: to_input,
        amount: 10000000000,
        asset_id: [0; 32],
    };

    // Call `initialize_counter()` method in our deployed contract.
    // Note that, here, you get type-safety for free!
    let _result2 = contract_instance
        .deposit(input_struct)
        .call()
        .await
        .unwrap();

    let balance_of_check = mycontract_mod::BalanceOfInput {
        address: to_input,
        asset_id: [0; 32],
        salt: 10,
    };

    let result = contract_instance
        .balance_of(balance_of_check)
        .call()
        .await
        .unwrap();

    assert!(result > 1);
}
