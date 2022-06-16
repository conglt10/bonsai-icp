export function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export const getBalanceNativeToken = async (web3, address) => {};

export const getBalanceERC20 = async (state) => {};

export const getBalanceERC721 = async (address, instanceBonsai) => {};

export const airDropERC20 = async (web3, instanceOxygen, address) => {};

export const transferERC20To = async (web3, instanceOxygen, address, amount) => {};

export const refundERC20To = async (web3, instanceOxygen, address, amount) => {};

export const mintERC721To = async (web3, instanceBonsai, address, item) => {};

export const airDropped = async (address, instanceOxygen) => {};

export const receiveOxygen = async (web3, instanceOxygen, address, numBonsais) => {};

export const getTokenPrice = async (instanceOxygen, tokenType) => {};

export const approveContract = async (state, tokenType, amount) => {};

export const buyOxygenWithERC20 = async (state, tokenType, amount, price) => {};

export const buyOxygen = async (instanceOxygen, address, amount) => {};

export const transferBonsai = async (instanceBonsai, from, to, bonsaiId) => {};

// get Plant Dict from contract
export const getPlantDict = async (instanceBonsai, address) => {};

// set Plant Dict
export const setPlantDict = async (web3, instanceBonsai, plantsDict, address) => {};
