contract;

// Will be pushing to std lib later
pub struct address {
    value: b256,
}

pub struct ReservesReturn {
    reserve0:u64,
    reserve1:u64,
    blockTimestampLast:u32,
}

struct returnAssets {
    asset1:address,
    asset2:address,
}

abi ConstantProductPool {
    // Trident actually uses bytes32 as a sole input in most functions
    // Amazing right?
    fn mint(gas: u64, coins: u64, asset_id: b256, input: b256) -> u64;
    fn burn(gas: u64, coins: u64, asset_id: b256, input: b256) -> []u64;
    fn burnSingle(gas: u64, coins: u64, asset_id: b256, input: b256) -> u64;
    fn swap(gas: u64, coins: u64, asset_id: b256, input: b256) -> u64;
    fn flashSwap(gas: u64, coins: u64, asset_id: b256, input: b256) -> u64;
    fn updateBarFee(gas: u64, coins: u64, asset_id: b256, input: b256);
    fn getAssets(gas: u64, coins: u64, asset_id: b256, input: b256) -> returnAssets;
    fn getAmountOut(gas: u64, coins: u64, asset_id: b256, input: b256) -> u64;
    fn getAmountIn(gas: u64, coins: u64, asset_id: b256, input: b256) -> u64;
    fn getReserves(gas: u64, coins: u64, asset_id: b256, input: b256) -> ReservesReturn;
    fn getNativeReserves(gas: u64, coins: u64, asset_id: b256, input: b256) -> ReservesReturn;
}

impl ConstantProductPool for Contract {

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


}
