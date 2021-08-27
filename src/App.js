import { useEffect, useState } from "react";
import { Web3ReactProvider, useWeb3React } from "@web3-react/core";

import { InjectedConnector } from "@web3-react/injected-connector";
import { NetworkConnector } from "@web3-react/network-connector";
import classNames from "classnames";

import { ethers, utils } from "ethers";

const injected = new InjectedConnector({ supportedChainIds: [1, 4] });

const network = new NetworkConnector({
  defaultChainId: 1,
  urls: {
    1: "https://mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
    4: "https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
  },
});

function getLibrary(provider) {
  return new ethers.providers.Web3Provider(provider);
}

const abi = [
  {
    constant: false,
    inputs: [
      { name: "rockNumber", type: "uint256" },
      { name: "receiver", type: "address" },
    ],
    name: "giftRock",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: true,
    inputs: [
      { name: "", type: "address" },
      { name: "", type: "uint256" },
    ],
    name: "rockOwners",
    outputs: [{ name: "", type: "uint256" }],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [{ name: "rockNumber", type: "uint256" }],
    name: "dontSellRock",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: false,
    inputs: [],
    name: "withdraw",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: false,
    inputs: [{ name: "rockNumber", type: "uint256" }],
    name: "buyRock",
    outputs: [],
    payable: true,
    stateMutability: "payable",
    type: "function",
  },
  {
    constant: true,
    inputs: [{ name: "", type: "uint256" }],
    name: "rocks",
    outputs: [
      { name: "owner", type: "address" },
      { name: "currentlyForSale", type: "bool" },
      { name: "price", type: "uint256" },
      { name: "timesSold", type: "uint256" },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [{ name: "rockNumber", type: "uint256" }],
    name: "getRockInfo",
    outputs: [
      { name: "", type: "address" },
      { name: "", type: "bool" },
      { name: "", type: "uint256" },
      { name: "", type: "uint256" },
    ],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: false,
    inputs: [{ name: "_address", type: "address" }],
    name: "rockOwningHistory",
    outputs: [{ name: "", type: "uint256[]" }],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    constant: true,
    inputs: [],
    name: "latestNewRockForSale",
    outputs: [{ name: "", type: "uint256" }],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [
      { name: "rockNumber", type: "uint256" },
      { name: "price", type: "uint256" },
    ],
    name: "sellRock",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "constructor",
  },
  { payable: true, stateMutability: "payable", type: "fallback" },
];

const wrapperABI = [
  { inputs: [], stateMutability: "nonpayable", type: "constructor" },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "approved",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      { indexed: false, internalType: "bool", name: "approved", type: "bool" },
    ],
    name: "ApprovalForAll",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "previousOwner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "OwnershipTransferred",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      { indexed: true, internalType: "address", name: "from", type: "address" },
      { indexed: true, internalType: "address", name: "to", type: "address" },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Transfer",
    type: "event",
  },
  {
    inputs: [
      { internalType: "address", name: "to", type: "address" },
      { internalType: "uint256", name: "tokenId", type: "uint256" },
    ],
    name: "approve",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "owner", type: "address" }],
    name: "balanceOf",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "createWarden",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "tokenId", type: "uint256" }],
    name: "getApproved",
    outputs: [{ internalType: "address", name: "", type: "address" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "owner", type: "address" },
      { internalType: "address", name: "operator", type: "address" },
    ],
    name: "isApprovedForAll",
    outputs: [{ internalType: "bool", name: "", type: "bool" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "name",
    outputs: [{ internalType: "string", name: "", type: "string" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "owner",
    outputs: [{ internalType: "address", name: "", type: "address" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "tokenId", type: "uint256" }],
    name: "ownerOf",
    outputs: [{ internalType: "address", name: "", type: "address" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "rocks",
    outputs: [
      { internalType: "contract EtherRock", name: "", type: "address" },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "from", type: "address" },
      { internalType: "address", name: "to", type: "address" },
      { internalType: "uint256", name: "tokenId", type: "uint256" },
    ],
    name: "safeTransferFrom",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "from", type: "address" },
      { internalType: "address", name: "to", type: "address" },
      { internalType: "uint256", name: "tokenId", type: "uint256" },
      { internalType: "bytes", name: "_data", type: "bytes" },
    ],
    name: "safeTransferFrom",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "operator", type: "address" },
      { internalType: "bool", name: "approved", type: "bool" },
    ],
    name: "setApprovalForAll",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "bytes4", name: "interfaceId", type: "bytes4" }],
    name: "supportsInterface",
    outputs: [{ internalType: "bool", name: "", type: "bool" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "symbol",
    outputs: [{ internalType: "string", name: "", type: "string" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "tokenId", type: "uint256" }],
    name: "tokenURI",
    outputs: [{ internalType: "string", name: "", type: "string" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "totalSupply",
    outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      { internalType: "address", name: "from", type: "address" },
      { internalType: "address", name: "to", type: "address" },
      { internalType: "uint256", name: "tokenId", type: "uint256" },
    ],
    name: "transferFrom",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "newOwner", type: "address" }],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "id", type: "uint256" }],
    name: "unwrap",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "string", name: "baseTokenURI", type: "string" }],
    name: "updateBaseTokenURI",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "", type: "address" }],
    name: "wardens",
    outputs: [{ internalType: "address", name: "", type: "address" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "uint256", name: "id", type: "uint256" }],
    name: "wrap",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

const other = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
    ],
    name: "buy",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

const MAX_SALE_FIG = 4;

const addresses = {
  rocks: {
    1: "0x37504AE0282f5f334ED29b4548646f887977b7cC",
    4: "0xBC0dAA15d70d35f257450197c129A220fb1F2955",
  },
  wrappers: {
    1: "0xE50ea3978E0902F7287Fd35Bf84864104dF13ba3",
    4: "0x689c8E7fA5DD2044F3a8f3465d96E1773fFaE5b8",
  },
  minters: {
    1: "0xC314D734EAe9B3926C15BC2C89596822B541EFfd",
    4: "0xC314D734EAe9B3926C15BC2C89596822B541EFfd",
  },
};

const Rock = ({ id }) => {
  const [info, setInfo] = useState(null);
  const [loading, setLoading] = useState(false);
  const [wrapping, setWrapping] = useState(false);
  const [unwrapping, setUnwrapping] = useState(false);
  const [manage, setManage] = useState(false);
  const [selling, setSelling] = useState(false);
  const [price, setPrice] = useState("");

  const { account, library, chainId: networkId } = useWeb3React();

  const getEtherRockContract = () => {
    const signer = account ? library?.getSigner(account) : library;
    return new ethers.Contract(addresses.rocks[networkId], abi, signer);
  };

  const getWrapperContract = () => {
    const signer = account ? library?.getSigner(account) : library;
    return new ethers.Contract(
      addresses.wrappers[networkId],
      wrapperABI,
      signer
    );
  };

  const fetchInfo = async () => {
    const contract = getEtherRockContract();
    const wrapper = getWrapperContract();

    const getOwner = async () => {
      try {
        return await wrapper.ownerOf(id);
      } catch (e) {}
    };

    const [owner, warden, result] = await Promise.all([
      getOwner(),
      account ? await wrapper.wardens(account) : null,
      await contract.rocks(id),
    ]);

    const isSetup = warden !== ethers.constants.AddressZero;

    if (
      result.owner === warden &&
      result.owner !== ethers.constants.AddressZero
    ) {
      setInfo({ ...result, approved: true, isOwner: true, isSetup });
    } else if (owner === account) {
      setInfo({ ...result, wrapped: true, isOwner: true, isSetup });
    } else if (result.owner === account) {
      setInfo({ ...result, unwrapped: true, isOwner: true, isSetup });
    } else {
      setInfo(result);
    }
  };

  useEffect(() => {
    if (library) {
      fetchInfo();
    }
    // eslint-disable-next-line
  }, [account, library]);

  const buy = async () => {
    try {
      if (account) {
        setLoading(true);

        const contract = getEtherRockContract();
        const tx = await contract.buyRock(id, {
          value: info.price,
        });

        await tx.wait();
        await fetchInfo();
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
    }
  };

  const approve = async () => {
    try {
      if (account) {
        setLoading(true);

        // get wrapper
        const wrapper = getWrapperContract();
        const warden = await wrapper.wardens(account);
        if (warden === ethers.constants.AddressZero) {
          throw new Error("Warden is wrong");
        }

        // approve
        const contract = getEtherRockContract();
        const tx = await contract.giftRock(id, warden);

        await tx.wait();
        await fetchInfo();
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
    }
  };

  const unwrap = async () => {
    try {
      if (account) {
        setLoading(true);

        const wrapper = getWrapperContract();
        const tx = await wrapper.unwrap(id);

        await tx.wait();
        await fetchInfo();
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
    }
  };

  const wrap = async () => {
    try {
      if (account) {
        setLoading(true);

        const wrapper = getWrapperContract();
        const tx = await wrapper.wrap(id);

        await tx.wait();
        await fetchInfo();
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
    }
  };

  const sell = async () => {
    try {
      if (account && price) {
        setLoading(true);

        const contract = getEtherRockContract();
        const tx = await contract.sellRock(id, utils.parseUnits(price));

        await tx.wait();
        await fetchInfo();
        setPrice("");
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
    }
  };

  const notForSale = async () => {
    try {
      if (account) {
        setLoading(true);

        const contract = getEtherRockContract();
        const tx = await contract.sellRock(id, ethers.constants.MaxUint256);

        await tx.wait();
        await fetchInfo();
        setPrice("");
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
    }
  };

  const setup = async () => {
    try {
      if (account) {
        setLoading(true);

        const contract = getWrapperContract();
        const tx = await contract.createWarden();

        await tx.wait();
        await fetchInfo();
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
    }
  };

  const priceMaxed = info && info.price.eq(ethers.constants.MaxUint256);

  const renderButton = () => {
    const btnClass = classNames("button is-info", { "is-loading": loading });
    const btnClassM2 = classNames("button is-info mb-2");
    if (info) {
      if (info.isOwner) {
        if (manage) {
          if (unwrapping) {
            return (
              <>
                <button
                  className={btnClassM2}
                  disabled={loading || !info.wrapped}
                  onClick={unwrap}
                  style={{ width: 105 }}
                >
                  Unwrap
                </button>
                <button
                  className={btnClass}
                  disabled={loading}
                  onClick={() => setUnwrapping(false)}
                  style={{ width: 105 }}
                >
                  <i class="fas fa-arrow-left"></i>
                </button>
              </>
            );
          }
          if (wrapping) {
            return (
              <>
                <button
                  className={btnClassM2}
                  disabled={loading || priceMaxed}
                  onClick={notForSale}
                  style={{ width: 105 }}
                >
                  Not For Sale
                </button>
                <button
                  className={btnClassM2}
                  disabled={loading || info.isSetup || !priceMaxed}
                  onClick={setup}
                  style={{ width: 105 }}
                >
                  Set Up
                </button>
                <button
                  className={btnClassM2}
                  disabled={
                    loading || !info.unwrapped || !info.isSetup || !priceMaxed
                  }
                  onClick={approve}
                  style={{ width: 105 }}
                >
                  Deposit
                </button>
                <button
                  className={btnClassM2}
                  disabled={loading || !info.approved || !priceMaxed}
                  onClick={wrap}
                  style={{ width: 105 }}
                >
                  Wrap
                </button>
                <button
                  className={btnClass}
                  disabled={loading}
                  onClick={() => setWrapping(false)}
                  style={{ width: 105 }}
                >
                  <i class="fas fa-arrow-left"></i>
                </button>
              </>
            );
          }

          if (selling) {
            return (
              <>
                <input
                  style={{ width: 105 }}
                  class="input mb-2"
                  type="text"
                  value={price}
                  disabled={loading}
                  onChange={(e) => {
                    setPrice(e.target.value);
                  }}
                  placeholder={`${utils.formatUnits(info.price)} ETH`}
                ></input>
                <button
                  className={btnClassM2}
                  disabled={loading || !price}
                  onClick={sell}
                  style={{ width: 105 }}
                >
                  Sell
                </button>
                <button
                  className={btnClassM2}
                  disabled={
                    loading || info.price.eq(ethers.constants.MaxUint256)
                  }
                  onClick={notForSale}
                  style={{ width: 105 }}
                >
                  Not For Sale
                </button>
                <button
                  className={btnClass}
                  disabled={loading}
                  onClick={() => setSelling(false)}
                  style={{ width: 105 }}
                >
                  <i class="fas fa-arrow-left"></i>
                </button>
              </>
            );
          }

          return (
            <>
              <button
                className={btnClassM2}
                disabled={loading || !info.unwrapped}
                onClick={() => setSelling(true)}
                style={{ width: 105 }}
              >
                Selling
              </button>
              <button
                className={btnClassM2}
                disabled={loading || info.wrapped}
                onClick={() => setWrapping(true)}
                style={{ width: 105 }}
              >
                Wrapping
              </button>
              <button
                className={btnClassM2}
                disabled={loading || !info.wrapped}
                onClick={() => setUnwrapping(true)}
                style={{ width: 105 }}
              >
                Unwrapping
              </button>
              <button
                className={btnClass}
                disabled={loading}
                onClick={() => setManage(false)}
                style={{ width: 105 }}
              >
                <i class="fas fa-arrow-left"></i>
              </button>
            </>
          );
        } else {
          return (
            <button
              className={btnClass}
              disabled={loading}
              onClick={() => setManage(true)}
            >
              Manage
            </button>
          );
        }
      }

      if (info.price.eq(ethers.constants.MaxUint256)) {
        return (
          <button className="button is-info" disabled>
            Not For Sale
          </button>
        );
      }

      const max =
        utils.formatUnits(info.price).split(".")[0].length > MAX_SALE_FIG;
      const formatted = max
        ? `${utils.formatUnits(info.price).slice(0, MAX_SALE_FIG)}...`
        : utils.formatUnits(info.price);
      return (
        <button className={btnClass} disabled={loading} onClick={buy}>
          Buy {formatted} ETH
        </button>
      );
    }
    return <button className="button is-info is-loading">-</button>;
  };

  return (
    <div
      className="card mr-4 mb-4 p-4"
      style={
        !manage
          ? {
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              justifyContent: "space-between",
              width: 170,
            }
          : {
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              width: 170,
            }
      }
    >
      {(!manage && parseInt(id) < 100) && (
        <img
          className="mb-3"
          alt={`rock-${id}`}
          style={{ height: 150 }}
          src={require(`./rocks/${id}.png`).default}
        ></img>
      )}

      <p className="mb-3">Rock {id}</p>
      {info && !manage && (
        <a
          target="_blank"
          rel="noreferrer"
          className="mb-3"
          href={`https://etherscan.io/address/${info.owner}`}
        >
          Owner
        </a>
      )}
      {renderButton()}
    </div>
  );
};

const Minter = () => {
  const [num, setNum] = useState("");
  const [managingRock, setManagingRock] = useState(false);
  const [numManage, setNumManage] = useState("");
  const [available, setAvailable] = useState(false);
  const [loading, setLoading] = useState(false);
  const { account, library, chainId: networkId } = useWeb3React();

  const getEtherRockContract = () => {
    const signer = account ? library?.getSigner(account) : library;
    return new ethers.Contract(addresses.rocks[networkId], abi, signer);
  };

  const getMinterContract = () => {
    const signer = account ? library?.getSigner(account) : library;
    return new ethers.Contract(addresses.minters[networkId], other, signer);
  };

  const mint = async () => {

  };

  const manageRock = async () => {
    if (!managingRock){
      if (parseInt(numManage) < 100){
        alert("You can manage this earliest version rock below.")
      } else {
        setLoading(true);
        const contract = getEtherRockContract();
        const rock = await contract.rocks(numManage);
        console.log(rock.owner, account)
        if (rock.owner && rock.owner === account) {
          setManagingRock(true);
        } else {
          alert("You are not the owner of this rock.")
        }
      }
    }
  };
  const clearManageRock = async () => {
    if (managingRock){
      setManagingRock(false);
    }
  };

  const check = async () => {
    setLoading(true);
    const contract = getEtherRockContract();
    const rock = await contract.rocks(num);
    if (rock.owner === "0x0000000000000000000000000000000000000000") {
      setAvailable(true);
    } else {
      setAvailable(false);
    }
    setLoading(false);
  };

  useEffect(() => {
    setAvailable(false);
  }, [num]);

  return (
    <div>
      <div style={{ display: "flex" }}>
        <input
          class="input"
          type="text"
          placeholder="rock number"
          onChange={(e) => setNum(e.target.value)}
          value={num}
        />
        {available ? (
          <button className="button ml-2" disabled={!account} onClick={mint}>
            Mint
          </button>
        ) : (
          <button className="button ml-2" onClick={check} disabled={loading}>
            Check
          </button>
        )}

    </div>
    <br/>
    <div style={{ display: "flex" }}>
        {!managingRock ? (
          
          <>
            <input
              class="input"
              type="text"
              placeholder="rock number"
              onChange={(e) => setNumManage(e.target.value)}
              value={numManage}
            />
            <button className="button ml-2" disabled={!account} onClick={manageRock}>
              Manage
            </button>
          </>
        ) : (
          <>
            <button className="button ml-2" disabled={!account} onClick={clearManageRock}>
              Back
            </button>

            <Rock id={numManage} />
          </>
        )}



      </div>
    </div>
  );
};

function App() {
  const { account, activate, deactivate, active, chainId: networkId } = useWeb3React();
  const rocks = Array.from(Array(100).keys());
  if (!account && !active) {
    const knownConnector = localStorage.getItem("connector");
    if (knownConnector === "metamask") {
      activate(injected);
    } else {
      activate(network);
    }
  }

  const login = () => {
    localStorage.setItem("connector", "metamask");
    activate(injected);
  };

  const logout = () => {
    localStorage.setItem("connector", "");
    deactivate(injected);
  };

  return (
    <>
      <div className="container">
        <nav class="navbar" role="navigation" aria-label="main navigation">
          <div class="navbar-brand">
            <a class="navbar-item" href="https://weliketherocks.com">
              We Like The Rocks
            </a>
          </div>

          <div class="navbar-end">
            <div class="navbar-item">
              <div class="buttons">
                {!account && (
                  <button
                    class="button is-info is-light"
                    onClick={login}
                    disabled={!window.ethereum}
                  >
                    <strong>Connect</strong>
                  </button>
                )}
                {account && (
                  <button
                    class="button is-info is-light"
                    onClick={logout}
                    disabled={!window.ethereum}
                  >
                    <strong>
                      {account.slice(0, 4) +
                        "..." +
                        account.slice(account.length - 4, account.length)}
                    </strong>
                  </button>
                )}
              </div>
            </div>
          </div>
        </nav>
      </div>

      <section class="hero is-info">
        <div class="hero-body">
          <p class="title mb-6" style={{ textAlign: "center" }}>
            Own blockchain history.
          </p>
          <p class="subtitle" style={{ textAlign: "center" }}>
            One of the earliest NFTs to ever exist, deployed on Dec 25, 2017 at
            9:01:40 AM
          </p>
          <p class="subtitle" style={{ textAlign: "center", color: "white" }}>
            <span class="icon mr-6">
              <a
                target="_blank"
                rel="noreferrer"
                href="https://discord.gg/q8aPXVCQDu"
              >
                <i class="fab fa-discord"></i>
              </a>
            </span>
            <span class="icon" class="icon mr-6">
              <a
                target="_blank"
                rel="noreferrer"
                href="https://twitter.com/weliketherocks"
              >
                <i class="fab fa-twitter"></i>
              </a>
            </span>
            <span class="icon">
              <a
                target="_blank"
                rel="noreferrer"
                href={`https://${networkId==4 ? "rinkeby." : "" }etherscan.io/address/${addresses.rocks[networkId]}#code`}
              >
                <i class="fab fa-ethereum"></i>
              </a>
            </span>
          </p>
        </div>
      </section>

      <section class="section">
        <div class="container is-max-desktop">
          <div
            style={{
              display: "flex",
              flexWrap: "wrap",
              justifyContent: "center",
              marginBottom: "3rem",
            }}
          >
            <Minter />
          </div>
          <div
            style={{
              display: "flex",
              flexWrap: "wrap",
              justifyContent: "center",
            }}
          >
            {rocks.map((_, id) => (
              <Rock id={id} />
            ))}
          </div>
        </div>
      </section>
    </>
  );
}

const Wrapper = () => (
  <Web3ReactProvider getLibrary={getLibrary}>
    <App />
  </Web3ReactProvider>
);

export default Wrapper;
