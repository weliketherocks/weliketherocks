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

const images = [
  "bafybeibkx5swmemvqkc6n3umzuaplcssrq6bp2uyh3n2vhdywzv6lszv3q/0.png",
  "bafybeid6g2ue77ioxviruwhbz77nz7fyyomf7c24c2ya7i725uto7plpxe/1.png",
  "bafybeigwsvacvsu7puct5p2wyenietreui6yealsshmc4w3cnlx2vtwgai/2.png",
  "bafybeihaszjogt4ksjzcx5abvqsfcxc4ow35nb33idqrzelbwget7sxtzi/3.png",
  "bafybeicll7pdbhxfsnejqjgsgjfspnxpv5g6rmkqrkty7mnfbgztlhnnxe/4.png",
  "bafybeiazo5mjnq5ot6l3msgbrwsqo3qc43czdzyc7goe4vxjlk4ciwan34/5.png",
  "bafybeie62no5b4pwobhcs2ritotdf2baiiw65sjraxyeabxr4ewtqu5534/6.png",
  "bafybeibrtcuqfuredutyvezpx4jixl34zps5tx54j4x23b56bhre4l4bmq/7.png",
  "bafybeihjtbnrkbsks4xjqyqniginmhxi4miwwq7cfderohicec3tsjnojq/8.png",
  "bafybeifjmbzw4623nkbrji5vmahgygtkeikl2id23fddym4fovspeargle/9.png",
  "bafybeibljith3s2p7bhewtfjabpssvsxchhr7peuok3ovksedai24steca/10.png",
  "bafybeihyg4rr22joidsj3iabhakrtzccfw7yu4e4jivi5k2g6dxzx37cji/11.png",
  "bafybeidl4vfgozexxpnd2f6jlrvzukg57w6rx7hsp4mqyhonfe2jqsofk4/12.png",
  "bafybeiegqsp5fhjfxjlxn4pz7mjyqrfufujl7q5b7tc4m6c54qwiui56dq/13.png",
  "bafybeibnfylvb5wt52snk4ysjpjva375qrsfuefmpazjips57vqh7qotue/14.png",
  "bafybeienhpn3mmhz6thd4fsompabimm5nrckkdmee5dmbttwoenscvq35a/15.png",
  "bafybeih2nzl4whby3boqyhmxduurcpxc42swsnrdclvlnkymm3e5sazb3q/16.png",
  "bafybeiefla4dqvtitzc5gcxzkfjsyqeglrmgiqf7otvb3fyfulycg6slbi/17.png",
  "bafybeicmbsfmms2uou2j2bnkk4zclwoame4g3gfrtf3uqldc7wynvjixdy/18.png",
  "bafybeid55k5gcprfldsm6up4gn2zit2yxkiulub2dj4ch2u3cvyyvi5spm/19.png",
  "bafybeieyvsycayibpt6ba2sheynybvwspdp4hmpd5korwan62d7xh4ifoi/20.png",
  "bafybeidgyyy7uyjdszhjmjdxydjvv2ml4yubkkoszhw7jqk5cnq4q5p5ku/21.png",
  "bafybeiabef6qwjur72567ontn2enb6q6a6y2nmrxe22dptvkjmekboqxbq/22.png",
  "bafybeiaky5urvqxfbqgw7cdnz3y2jfgmmn5etkdiyststppncjt4obmsem/23.png",
  "bafybeihzdaz2zdybzruzaylgodrc5wnc4ovdgxecd5vr6cnmxiwa6bsznu/24.png",
  "bafybeid4k5owwkp2iwpwysx2fkrm22cw3uocpibiayefbyq3djndckehky/25.png",
  "bafybeidisyhllcubgt7fonj75wba5pd5fav5ouyp2pfobknj65ddt77gtu/26.png",
  "bafybeihy5ebpxx66nrit6ab37di4o4fnudxuo6uynyfyw6usqeomty53yi/27.png",
  "bafybeie7p3vv2mife23ny32sryybfvkthvtkhhr3odaz6ez3yxkztchylq/28.png",
  "bafybeidi7fynufmcpf62icnl353cpthyvlccvzmiagb347wjpkaeszm2uy/29.png",
  "bafybeiggt4qctt4zc4ok2xrabbbdiftod2mk2keaq3fedtvlfomjqwvsri/30.png",
  "bafybeihp7dluwbvde5xhcsde4n7tfhjkumpk7fkowslrhgwjsciykyxv2e/31.png",
  "bafybeiepuyb3muwc4cktrehvy7evqh2b742gshrukvvpas33kxvsubmihy/32.png",
  "bafybeicmdrbgecx74o4a6vxqa46xdiw3skhtkgi45c5wu2psj6posdqcii/33.png",
  "bafybeigcfno3crdjkorj4zrmb7ljqzjmeazycvyk7xxigufmdtabrnzlqi/34.png",
  "bafybeibqhj4w7vpeylpbmsoea2tfcxhnc64vwirdzrede2qoi4aj2h55om/35.png",
  "bafybeib2hmg65ee3vu7wz27sb42lknkv3olu23qhemqticymqnfzmkn54e/36.png",
  "bafybeifs2ebu6abo735ju7j4md6t3hkadxz645k57ucdizvqgciy4ps62i/37.png",
  "bafybeif35al6hft2zxiclyht4o67q6ikyky7h3mhfo5hutbyfzynolne4m/38.png",
  "bafybeibq6vhh3ow6ttibcbv4aepdl4m4rptf5zjsss2fhtjedecskzkhpy/39.png",
  "bafybeihtdemergxlzro3gqbnw6lnrwsv5egk5c4byhgg53645hbyztnifu/40.png",
  "bafybeigsv55x7wl3ylvxgsocjlbuacl6msd25uivlgnvnan5imosxs72ue/41.png",
  "bafybeidmjlrgqnw5jbyaugdnqoznfd5nhbmideuzisc3pihevofanvcf7m/42.png",
  "bafybeiaho2ryguxp4kikrx6l4qqnmioilvlxtzukdzazl2e2sjanjg3j5i/43.png",
  "bafybeigyxtw4sflpjzhqojrceazskx7r7di2pzm6lmm5574pkjvlu5wprq/44.png",
  "bafybeibhstjoxjpb3ifqg2pkjbjt2begv7o6yyqv2nvq6mytmpyx63pu2q/45.png",
  "bafybeibd2a22uu5nwogbnbcd2j63jhoxzebx7jiw2mz4of5eipimp3vlfm/46.png",
  "bafybeihej5csmxgut63guxwpcmjlpcqydeswac3ml3daxsxyaool5ubqrm/47.png",
  "bafybeifv25l3j7vuio4fpibldnz6pnc7ulcpjpkm56uiy34ix4xhayhrea/48.png",
  "bafybeidavpbhl5kmw2tw5m77wdadvyii4cn3kj2qa774kzqxt5hhlfk6de/49.png",
  "bafybeih3myim7cot6qgkufpf4qax4jwfosb3ay2j7ngnp23nlndbak7gbu/50.png",
  "bafybeibjr4isxcym3br4dw3qyhg2lqfxs7swnej6leovld7o6j4caiv2eq/51.png",
  "bafybeifbctyqcaw7omczjuhtusrqj6inph7duxrummkjwu54aeljenjyea/52.png",
  "bafybeihtrcyp5dvmtlrumyarinhkplroynd2mhqprbpkml6pjrhjh5jqby/53.png",
  "bafybeie3bjbnkrzz6qxm6prwkzbqson6mioo2sugkb3x5yrihad34s3jyy/54.png",
  "bafybeib7sv5z7imkhpaooyrczhpblbupqlt3gqbcwq2qxpqikbdruhj7h4/55.png",
  "bafybeifmlm6mrnyulltqnteod7gte5gjazpqcgfwwpkakrz3wfy3jdogsu/56.png",
  "bafybeidfio3epkf6fpqyz2phkfvljakcezwilnfnkuuiywm5temfcaotiu/57.png",
  "bafybeifz6omzulksux26v6edmnbzlgibbypzubrkyx6ldlygocnniemchu/58.png",
  "bafybeigg5b7ekwbhscgpfcbkvlyvbfchwlgzfap7fijsq2ukpzz2em7sja/59.png",
  "bafybeia2bjfwpgonkj7vhhwg77uclpkw6yqollcvaxjxwwriqt76idow4a/60.png",
  "bafybeiag2qrodx2ccswb3i2s6y6bk7rtvh7tisrk4xijyl66sb6vuwelru/61.png",
  "bafybeibu3mvhofxxm5lsvzuhidepfcxlimdbzz3khisp3irqe66w53hnri/62.png",
  "bafybeidlrjyyrhyxibd72ckqptuejqx2kddbcqcpwydtz3vajun2yo4j3a/63.png",
  "bafybeibnfwgnv5yiapnx6fhorzhtsbrxyzoheexwmlmr2a2xkxy24keh3q/64.png",
  "bafybeiaywoattfnnyzoqdrovfvyulnj44ypkwqxsjz6knsrsr5omooklja/65.png",
  "bafybeifiyzfn5og6gr74v6oe4ytwoztszn6sjjzqprehjdew4xge35fyte/66.png",
  "bafybeigj57sqg6lwnt2hffigvvvwhpt6ir2hgujmgnqzm6l23rmsqdanei/67.png",
  "bafybeiel246xxkwgtz3li7iitx5ujjshjdip7su2zzongk63zgxzhzxuoe/68.png",
  "bafybeihj7grfgvonzjcvd2enc3kovwmwcwhhysddb2txb5x2updha4r7qm/69.png",
  "bafybeicob7xlej5qdwotmejiizt4dhuvoq3fcdso3fsfcfabokx7hjva2u/70.png",
  "bafybeigpzytgwmpdpig3s4l7fdg2w7627c4tz7gxqa742xo6uakmyze7qa/71.png",
  "bafybeihze2fkvmli5dm73ymiqztgdni27j3ztffmn2j4syr5wx4naejqiu/72.png",
  "bafybeia5falyzlwyt5zhhrkj5xkidjplz4yuaq5ppzs3mmml4tbgvgbcgq/73.png",
  "bafybeiexu6gltckfabwhvjmrrq6dokxnfdxydgzuzc4pwehp4asyji7dsi/74.png",
  "bafybeihiyvsc4isfvziwo5lg2bqnsoeyx545awvqvyk3afyireviercg2i/75.png",
  "bafybeiewjw2bmvclvewxpish4b3h3gokqbvp2rxkuklmroys73s2casno4/76.png",
  "bafybeifiyhndowzs5ohsbu6oo3jp2efdyg5r7koiyagbecnc3l3jxtgt4i/77.png",
  "bafybeibruwz6z4v2qodbuovpgctiu6qq4xpjgdyvrp5fqih3v33hba2tgi/78.png",
  "bafybeiatcunvjtmdhgiz5gaqnc63jvoe4ch5tf3gc2nc63jgdbjnsfnrce/79.png",
  "bafybeiekjthxvazasrv2i2fav55xnqcrww23k6z5xa7vbq6ygpj5d4y7nu/80.png",
  "bafybeia7x66ub5ninxssddqqhcjg7lhkpajucgjen62haljbtpo2jcl35y/81.png",
  "bafybeibgthwxybiyai3i3tismoujkogh4xtipobm6ez2j6kjpdgtbx5rie/82.png",
  "bafybeifg5blbog3h7knabnprws7lrt3e3owjc7zqhg5e442hdnmzhpmraq/83.png",
  "bafybeihssuwji6vdi6sxaqjifso4o7cdsyxaexfpsbxswqcljgi2k4fcna/84.png",
  "bafybeidwih3zspn6r6hnvrihwhggq7mifq6p5keitcmsuucwu2be3yiygu/85.png",
  "bafybeibwh7gmwgjwjw3siysytkhyiik3rx5zml5mtqzr4dah65mojlid2q/86.png",
  "bafybeiagfudwfwbc52kbxjvfngkdmy3dgj3dd3rptvtjxmw63tgnfrgtja/87.png",
  "bafybeifl2wrn3ewx4oh5iw3kh2uctbm2wdw4c75g2ekxxnvif3u3x22vru/88.png",
  "bafybeibmxm32pspx2bmpbvf32dh67qg5z4kmqqpuierdo5sbiwdfhz76uy/89.png",
  "bafybeihouhmonqdr4scfsgazyenulsl4krvif2l4v2xrhpwi454yh7zsfa/90.png",
  "bafybeia47xlh5g4s3b5wf2um5hixjrwvk2njnpzdmizr5ayxylvmrh256y/91.png",
  "bafybeifyltspgtm32zn6v5w3jasqkv5nkyugvk6s7btvjyehmllybers7m/92.png",
  "bafybeibch2274okimr24j27n7xpxl46iq63f5ros43rp4mzvihuz6hdtzi/93.png",
  "bafybeiefji3z6v3aqemjf4cyeqkb2r4cbr4hzqabkgwc5gbm2isv2kjqxq/94.png",
  "bafybeigzqm4h3mvmulviqo2sao33dncd4xmnrmemt7jk4luhsl34pmputu/95.png",
  "bafybeiaskeyvdkkp2hnpiaww3zhiewhxiq57zha6wshktyjdl6ivvijoia/96.png",
  "bafybeic2arp2fuuocdqdcx7tzjgl6m4jfozty7mjt4mvyffjqh2y3oz33y/97.png",
  "bafybeidej2nunivmxwsrpqyxmurnflproqobzv3pm7sx3uudpb64cawcxu/98.png",
  "bafybeidqpcfb6vg3xevz3n4jyfcl5s2nftftgdqhrnuclcwrsc6wgb2g6u/99.png",
];

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

const WRAPPING_ENABLED = false;

const addresses = {
  rocks: {
    1: "0x37504AE0282f5f334ED29b4548646f887977b7cC",
    4: "0xBC0dAA15d70d35f257450197c129A220fb1F2955",
    default: "0x37504AE0282f5f334ED29b4548646f887977b7cC",
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

function imgError(image) {
  console.log("here", image.target.currentSrc);
  image.src = "";
  setTimeout(function () {
    image.src = image.target.currentSrc;
  }, 1000);
}

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

  const getMinterContract = () => {
    const signer = account ? library?.getSigner(account) : library;
    return new ethers.Contract(addresses.minters[networkId], other, signer);
  };

  const fetchInfo = async () => {
    const contract = getEtherRockContract();
    const wrapper = getWrapperContract();

    const getOwner = async () => {
      try {
        if (WRAPPING_ENABLED) {
          return await wrapper.ownerOf(id);
        }
      } catch (e) {}
    };

    const [owner, warden, result] = await Promise.all([
      getOwner(),
      account && WRAPPING_ENABLED ? await wrapper.wardens(account) : null,
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
        let tx;
        if (info.price.isZero()) {
          const minter = getMinterContract();
          tx = await minter.buy(id);
        } else {
          tx = await contract.buyRock(id, {
            value: info.price,
          });
        }
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
              {WRAPPING_ENABLED && (
                <>
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
                </>
              )}

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
      {!manage && parseInt(id) < 100 && (
        <img
          className="mb-3"
          loading="lazy"
          alt={`rock-${id}`}
          style={{ height: 150 }}
          onError={imgError}
          src={`https://ipfs.io/ipfs/${images[id]}`}
        />
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
  const [managingRock, setManagingRock] = useState(false);
  const [numManage, setNumManage] = useState("");

  const manageRock = async () => {
    if (!managingRock && numManage) {
      if (parseInt(numManage) > 99) {
        setManagingRock(true);
      }
    }
  };

  const clearManageRock = async () => {
    if (managingRock) {
      setManagingRock(false);
    }
  };

  return (
    <div>
      <div style={{ display: "flex" }}>
        {!managingRock ? (
          <>
            <input
              class="input"
              type="text"
              placeholder="rock number"
              style={{ width: 200 }}
              onChange={(e) => setNumManage(e.target.value)}
              value={numManage}
            />
            <button
              style={{ width: 92 }}
              className="button ml-2"
              disabled={!numManage || parseInt(numManage) < 100}
              onClick={manageRock}
            >
              View
            </button>
          </>
        ) : (
          <>
            <button className="button mr-2" onClick={clearManageRock}>
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
  const {
    account,
    activate,
    deactivate,
    active,
    chainId: networkId,
  } = useWeb3React();
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
            <span class="icon mr-6">
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
                href={`https://${
                  networkId === 4 ? "rinkeby." : ""
                }etherscan.io/address/${
                  addresses.rocks[networkId] || addresses.rocks.default
                }#code`}
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
              <Rock key={id} id={id} />
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
