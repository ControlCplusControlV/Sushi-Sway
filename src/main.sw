contract;

enum FizzBuzzResult {
    Fizz: (),
    Buzz: (),
    FizzBuzz: (),
    Other: u64,
}

abi FizzBuzz {
    fn fizzbuzz(gas: u64, coins: u64, asset_id: b256, input: u64) -> FizzBuzzResult;
}

impl FizzBuzz for Contract {

    let MINIMUM_LIQUIDITY:u64 = 1000;
    let PRECISION:u8 = 112;
    let MAX_FEE:u8 = 10000;
    let MAX_FEE_SQUARE:u64 = 100000000;

    let swapFee:u64;
    let MAX_FEE_MINUS_SWAP_FEE:u64;

    let barFeeTo:address;
    let bento:address;
    let masterDeployer:address;

    let token0:address;
    let token1:address;

    let barFee:u64;
    let price0CumulativeLast:u64;
    let price1CumulativeLast:u64;
    let kLast:u64;

    let reserve0:u32;
    let reserve1:u32;
    let blockTimestampLast:u32;

    let poolIdentifier:b256 = "Trident:ConstantProduct";

    fn fizzbuzz(gas: u64, coins: u64, asset_id: b256, input: u64) -> FizzBuzzResult {
        if input % 15 == 0 {
            FizzBuzzResult::FizzBuzz
        } else if input % 3 == 0 {
            FizzBuzzResult::Fizz
        } else if input % 5 == 0 {
            FizzBuzzResult::Buzz
        } else {
            FizzBuzzResult::Other(input)
        }
    }
}
