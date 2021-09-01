// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface EtherRock {
  function sellRock (uint rockNumber, uint price) external;
  function dontSellRock (uint rockNumber) external;
  function giftRock (uint rockNumber, address receiver) external;
}

contract RockWarden is Ownable {
  function claim(uint256 id, EtherRock rocks) public onlyOwner {
    rocks.sellRock(id, type(uint256).max);
    rocks.giftRock(id, owner());
  }
  
  function withdraw(uint256 id, EtherRock rocks, address recipient) public onlyOwner {
    rocks.giftRock(id, recipient);
  }
}

contract GenesisRocks is ERC721 {
  EtherRock public rocks = EtherRock(0x37504AE0282f5f334ED29b4548646f887977b7cC);

  using Address for address;

  string private _baseTokenURI;
  uint256 private _totalSupply;

  mapping(address => address) public wardens;
  
  string[] hashes = [
    'bafyreieoiyches3w2yyxim63yhuqj2esbvxqmkfepr4wd7qdr46etshoee',
    'bafyreiebbwh7h4ygryalx33p63kbkve2im72c6lj7746in2ts3trxqr5xi',
    'bafyreif5igmqc5zapujnmridh4ttysvvrtt2kx2pcoddozngcj72rkbrym',
    'bafyreifypwtxfwcwno5totiyj6jei2564hq3xxjebj7ocgalub45vzsd34',
    'bafyreid6ew5m3vunwalc45ddvsrsdwmeaz6tgvqzo6nfpotffbh3i643iy',
    'bafyreiays5vqnvgqyxasvmoiu4cnoi4slck3yhnqt45cklitn6pdzreoce',
    'bafyreigxhynuriuoc2gd25yjpanym56yukv2sai7vtkl2p7llzdw3x6koq',
    'bafyreidl3qg6cwzudsjmjp2dgr7poy7mzrtpcxrddvfo2h4blbgzgiujeq',
    'bafyreicyy4cjbhmvsx7ev7jvda4figj7mf3gz6ylw7fafin4cct6m26cle',
    'bafyreicuivxwgbp6y4p3co6weqqzpysa7gmunwg32eytkmppolsbme5loi',
    'bafyreiac6slo6qxkwz7nqfomsh6ghjusu7wazyoe62vv5hhjtmhx7b75wa',
    'bafyreic2hb7wpgi5k3u3s52ak6sht234fcvwuv4a6vo5vc7x3uns7hljwe',
    'bafyreiajisvfhle3nz4kpugb3fy2edulrqgc4yd3vsmyqce7jwchpvv7lq',
    'bafyreihx2jrxteirjche4he3ioilkp4evbkyfcw7pi3dentliejsfae5se',
    'bafyreihuj7ddlcrco4wwkz3cfyjgrjgto3cuqtatsupy3wk3axwzudkani',
    'bafyreigfc5hqfzec2m4g4ibnxtm4xlqgyasdni5ugvisrj25ocla47b34e',
    'bafyreid5qleu2yqcbg5j3gap33gjkxpnqy43irbnkigekzq5cixj56bvg4',
    'bafyreieo35bcrls7hnirgadbgqe5ytfj4qhib4vq22fl4tpc73ptjubrqi',
    'bafyreidrwa33rh4cwvaa7xnya6u62xkvms4jj7qxubqdzxxuswnrhjsdru',
    'bafyreig4525gf5v5g25n57cgmefkr7g5klysajlwljkvkwskq53fckmzfe',
    'bafyreihu35tdhnv5vuhmb3vxmdhlittgvh2yvjro3bykrguo6ys44wyuxm',
    'bafyreiekacg4zpxlltkykbgjnhsf42wgi7akotukvnp6gicpajkhzrwdmu',
    'bafyreifjnwce4lctvwbmvmbci3dncdlahsvnts33yxkgb37d3qxp753eea',
    'bafyreiebxct5l7kahnfkdncp3rkty36y2nxogtmv4rvtzyxw4fdjoefdny',
    'bafyreib22cfbrsug2fokofrndu5awayyn3ij7y752gvnh2ehlynxakvxvq',
    'bafyreihhvio66f3mkbbkxleztpa34g572yl2mjfxbzs3677oyi5pxeag6u',
    'bafyreiahzltde3hqg2wxf4ewysj3x4i6qozshbu4hthflriy62zi64dwmu',
    'bafyreic4fldbzcn6j4zt5fi7owsavksrqkuuly2gg3saazvkyno5ggkx6a',
    'bafyreifcrv3kkw6jgpmj4bagxbeh6dkv2oab757ueaacvzq4xzswbhffv4',
    'bafyreiaxxhss3jepyy24yvugcaruf2wtr73plcv67cwypiknnbufqvk7gy',
    'bafyreihqe356tzs2w27rlckgyj3x4dqp7prtdrt3nh5vgorwkxqoxumpnq',
    'bafyreiat5xghn5upnuik7cg63x664bzijvlifla2nayncofwx5tavz5p2q',
    'bafyreiamhlscfklp7simix3c6znffmmwyncs3iqfhk3kni7i22a3x2vpqa',
    'bafyreihrtss4xppucluh7v3pfdihyc62nk5ff3pgt54cgc626fnhkawji4',
    'bafyreicpfiordskkahxmlzkkrccsjcsuiz7fplhtr75mzqswnovmfk4u7e',
    'bafyreidptpol2xi5jqnxen3aug563destp7vdjexkxfjcpvkjor6fko6mu',
    'bafyreicpweuqoz32ce5zcqx2yofp7wudo6vmkimxib2f3vvfnd6wzdm5ou',
    'bafyreihicdm3ga62g6terqytj76jcj4q5fqptbjgr5s2twnpqfdxq6hnpa',
    'bafyreia5xn7ev7nrcboxi6smrwnd4pedttgb3qf4xuxrrjepatrez4yse4',
    'bafyreihfypx557ipvheqf3qolt6fllgt3tszoaerfjp65dboycpcmfzlny',
    'bafyreifqsdqayngmuc3kp5nhnkjbqgj7uoc6nm6szw3fovm23b27mj7gfi',
    'bafyreiebswrzpx2eqqr5sb4lxjayvvufccqvzhzc6cvds7hu7tw5v2pwoi',
    'bafyreignlctk2l4nxtfmrwfu2qgq2zr5j45tsdo4lv4gobod5pewzzjray',
    'bafyreihxalsghdr322q2iql63sdxnowvi5gvvy3n45yzceb64u4ryi2l5m',
    'bafyreicb3lnlv4r66tn3smeu6cdiseymxqywiaxcvh7hqpnno35ud5tjaq',
    'bafyreiaxvy7vwqnll4ya65lntq2usreclrc6ivs2jypn4agkuxltccpjfu',
    'bafyreifw4shigdpeeltimpkab7iamfpxcwflz5ex3zwbcsh4dtv6vd2bam',
    'bafyreigaw626gxpmj5igre4anqjs3aiiyc2odmftvryyxc7izcgv2treku',
    'bafyreib7f5rhn5sx6z57sinidc6clz5h7xxxen7kxrbqst5exmygmy7h3i',
    'bafyreifq22ly7wr26tjham7zn5am3zycrto2sarqb23miqj5345loa3bfm',
    'bafyreic2awaltcxydeumqgza2tz27xxao232pcrwoes6huhkernaa4xn6m',
    'bafyreihtphtv32vbh7xkxpym6xj72mehimoygvhrrm7bn76p6qtmqcccfq',
    'bafyreid2nxjhw5clyap4ynpeb2cxk47drfcthmc3ft6vedn36blb6rpf2y',
    'bafyreidavkuxuqogngjwq44q57th6nm6nnz3ysthda2ahcpgo45lqoabb4',
    'bafyreidxzh2xdmbrxz6zmdgibw5rpsi5v3okltsot5xijd4kxoqwccqrmm',
    'bafyreidmpasgiskdejiyu7ls7rtohjjk4z6yg4sitnfyjjbxfdd32j3orq',
    'bafyreidftv2bb4gs4ga455v635kb2qjcicsk5d35pl6jk27smhfrsklxiy',
    'bafyreihb3lzzz7ix4trwrcgy7lejdqoj55m6nhx2hdukfqhpx57xy3mvrq',
    'bafyreibubwkh26mwqjenabtdanmmorp5y6tkd3t7s4iyep6uck5esuvnw4',
    'bafyreig53sxnz5mtryqf7zszohc653xqbasi6htizzt7ljat7vqw3w272u',
    'bafyreifh6egt53wiw4em5npl3lnuklturg3qcgxdnjozptrkhfpa3th3xe',
    'bafyreiax5kuanglij4jgtm3qy3mmie3bblc4ewuuk6p7eoxqjicd7bgmhe',
    'bafyreibzlnhdhkcnqu3hj3icagb6ksfvkfhdkfreok2vyiabx3itodp43i',
    'bafyreif4rhaukizla3ze7zoldbdrn3rvrf2o4vpiq4uvboz2hckemvppqy',
    'bafyreiaz5cv3qz2ogth3zt6ppj2txdpxboeyjlxh2r44llgbuctkpsgcm4',
    'bafyreigcawhwy4ydqxpt2t2p245xhmykqlxdmjl5dtd4tjfnpasklnkq3i',
    'bafyreifyrkr4u2gra75k7saomlc7za4eve5666ay2slvmshnxkmxlkhplu',
    'bafyreic6q5s6crfll75dpmblygzp4ioan5r6kha4vymbfqp5vokhpp7eu4',
    'bafyreig2r2yfx46m4wia6t4uaap3ypca7gedulb5nkzpli4dttvtdos4hm',
    'bafyreiemv4cd6mym2xecsdi476gsialw5z2x6xzsifxy3x4lawws7cqony',
    'bafyreighevjewuigkrxdjbfkq2esxf2obcrlywj2dinkvagt2g7esspi3m',
    'bafyreigpocnftdr2ge2zdqpy5pbdtpfqnqyxt3f4zp6si7uxxib5zh5usq',
    'bafyreidmtaetfcl3r3l3wgcg37hi6iqx2jbcutsoecyeqtjhpfkafcknsu',
    'bafyreifcroutmcauorazt3nikkqjsijxz54btk5jmmatcvmrzbibr3gtnq',
    'bafyreihyhvvqjvql3qiuoeqw52j5liljovlogx756psyea7kb3a3bwywyi',
    'bafyreifcsgxo2ykisavx2dka6qxp6ogup74kepkxxfaoxy5eipidyzrvoi',
    'bafyreibinyymtskbtxvtwjyxh45snhcj4e5ndaxgazohe6glumunehbykq',
    'bafyreifl7mkpeam33dh5ivcqn5bfw4qcygr55u5wnmfe4hxyu2lgnjauaa',
    'bafyreicrkuxqcj7gehpzirtrsda4o5cyg6r46gsfpxdo2vfbzi2yzwecya',
    'bafyreifanwtx5gwgyt6r3nbrcy6732qgcd6ortlhivx7kzxmeasj7w6qzu',
    'bafyreie3llx4gst63uuqyvjhl6ektfvzbstjqoie335iehwjgky2r3k7le',
    'bafyreibhipkz5toooqxd2gnjkhtzlxtgrsf563mbhgahz7667g63st7ura',
    'bafyreibrougha2kgrzixuux46qnfuq5xb2mw24dkdt6vrjuzbdns56kzim',
    'bafyreifbns6dbwfpk4mmy7vsehovi6mjrxldz5w2zojzwcttfqkwql4mu4',
    'bafyreibw2z3w6um45oq4jlnwpvoppcgyl47qjewztgxh56lrerjznn6xse',
    'bafyreiftfpryvqtymuawqzy263hp2lo2szf4jctllidnw7w7h3tpgqrubu',
    'bafyreiazomnwgr5urfc7jydz7iglls6gygpnsbf4oe6zzdujgotcee5faq',
    'bafyreiaileqd5plia43nhww3xuhnvkihlt5gqgc6jm3vuyuyzpsx54xpvi',
    'bafyreibtr57dnt4pcisnhfmnvgcqyqe2c6vnu7vf7hefttk23rtg52xiea',
    'bafyreiexg4elf3gusrbyomcelv37tyen7zxhmhha52csljsfox74p376ia',
    'bafyreidqieggnvly34kpkdnc4vvr7up2ypc7udqq464cc6pwehg7jkmxhu',
    'bafyreibvq4luzc5fwtb5shvk3c5plqwati6iyifzsa5mp4irzlrfjvvqmi',
    'bafyreihi7gzvefo3rrttdoeqf2dmoun6pk2rjulnac4izl5ldeas7nkd5y',
    'bafyreic5lud6g33mldlwwj47d4lmjfbwbxqy3ns6rluk7qimw6tq7fyf5m',
    'bafyreihx4qmoc24pclhroquufvotsolt6lslylluc4skdfe3shvun25oee',
    'bafyreibikvvnzlpt6ugjhmmrqk3txi4gffdupdwmcah5aw4tabed32ih6i',
    'bafyreidygh7d2mlwykkmwupg3mq3kwabtovltfr6vfmoqvwdl6ubzhszie',
    'bafyreib7godh3ldf3bgb6wwbk2xhby4xjbkhm263r3lgmjzvrmiarmptrm',
    'bafyreifn6qlky3xqo3a53537dcus5syfqikrnok4zrjegmee53roy7trrq',
    'bafyreiaxkuuooo7fsn76rzqg2t7f65ndaspwvlbjyyts7iacrppzra7mpq'
  ];
    
  constructor() ERC721("Genesis Rocks", "ROCKS") {}

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(tokenId < 100, "0 to 99");

    string memory baseURI = _baseURI();
    string memory tokenHash = _hash(tokenId);
    return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenHash, "/metadata.json")) : "";
  }
  
  function _baseURI() internal view virtual override returns (string memory) {
    return "ipfs://";
  }
  
  function _hash(uint256 id) internal view virtual returns (string memory) {
    return hashes[id];
  }
  
  function totalSupply() public view virtual returns (uint256) {
    return _totalSupply;
  }
    
  function wrap(uint256 id) public {
    // get warden address
    address warden = wardens[_msgSender()];
    require(warden != address(0), "Warden not registered");
    require(id < 100, "0 to 99");
    
    // claim rock
    RockWarden(warden).claim(id, rocks);
    
    // mint wrapped rock
    _mint(_msgSender(), id);
    
    // increment supply
    _totalSupply += 1;
  }
  
  function unwrap(uint256 id) public {
    require(_msgSender() == ownerOf(id));
    
    // burn wrapped rock
    _burn(id);
    
    // decrement supply
    _totalSupply -= 1;
    
    // send rock to user
    rocks.giftRock(id, _msgSender());
  }
  
  function rescue(uint256 id) public {
    // get warden address
    address warden = wardens[_msgSender()];
    require(warden != address(0), "Warden not registered");

    // withdraw rock
    RockWarden(warden).withdraw(id, rocks, _msgSender());
  }
  
  function createWarden() public {
    address warden = address(new RockWarden());
    require(warden != address(0), "Warden address incorrect");
    require(wardens[_msgSender()] == address(0), "Warden already created");
    wardens[_msgSender()] = warden;
  }
}