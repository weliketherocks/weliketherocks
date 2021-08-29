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
}

contract WeLikeTheRocks is ERC721 {
  EtherRock public rocks = EtherRock(0x37504AE0282f5f334ED29b4548646f887977b7cC);

  using Address for address;

  string private _baseTokenURI;
  uint256 private _totalSupply;

  mapping(address => address) public wardens;
  
  string[] hashes = [
    'bafyreif3ikd5hb75d4ec3wcnj34uoh3r33cql3znqaehs6tuimankltdyu',
    'bafyreig6akjmkp6v3zfkntqtm5fmwe3djiehu46hecwv45iymyd6stsvpy',
    'bafyreifxcb6vogyrqiae23slggkqfjevopaqtff5uokzu72zsmoxm4nxam',
    'bafyreiewp5kdtthwbxb24jwthcvj5wxgxf5olzbltuh6qi3uzaqsyqa5oi',
    'bafyreieitwcyc3dtm5rbq6zopfkbnlinmrm2o23jggwxoqo3gcafvxao2a',
    'bafyreiafxm4dfmuuieoembvan62adxyeih6slvb2hjsll656vnuznhfyhi',
    'bafyreib6j3jvdayllsuhhv2fvmbkgqd3eckh3itesfa66qhhpp5pbr4u6u',
    'bafyreidfu5ruujlaj642roqg4jo56h2v5yv5vhqe2rkqsw34ell77xyej4',
    'bafyreiaygm56l6nsnlagjdwkxacrywsudpmdwreroshkc7opcgy2yjbeum',
    'bafyreifqc64x6ilwo4ef4t4l6qj4hwjhu5isboolpwt6nsnmiqcs7622cy',
    'bafyreihb3k6gw53jrqun3jnckp7pod5bqybvkayjkkdoheud4anoshqese',
    'bafyreihn6myktiiemt7cgdaglgklh3mst52ip7lzodtgeons3fwtdyk7gq',
    'bafyreigiijh4i5okhmf2wzf76xqzzwnjrytr2ffp2hwzahyjtnlz7g2zie',
    'bafyreiabar4h73ctmc34sp6p32ewo72py2ot5meq4q2ihy3v4owav75rfy',
    'bafyreihoxzvxzej4bmmgc7xiz7ixlvm54ipr2ucw5o32m4nhc7dy5mkcuu',
    'bafyreiexzn3kdshgb7obb4kcch5ehu3utpeclczi6mapzntm5rl56qxvm4',
    'bafyreiexmeqnshafd532f7winpx453jpvtiojtktt4pi75suotqf7y7j5u',
    'bafyreicnti755uxsgsbysb6qpdm5nepeit5pccsdu7d7z5o3sni6ulk4kq',
    'bafyreiba4h4k2cloucbfwng5peet5bxa25pkmjyjxjmveidzd5qb6ukxy4',
    'bafyreigob3iikzdythb4wf5zwu44qm4pixr7ztsg2htz22pozpvoobmjba',
    'bafyreiez3cgaomdtljgccnvqevri36ala3w2aq7i2xqiez7t24jc2itlly',
    'bafyreie3ciakhgp2hyadxpb7b445vg6jzkjcmujmyvi4os3bxldb7ymlni',
    'bafyreia76zaiqm3abtmcqra3l4pbtr5r7yuitsxdm2ph4zp6nrxrexn2r4',
    'bafyreientdekpv6psibwa74lsmgchqt7nhv4wz2w557ymschndda4juroa',
    'bafyreigoy7bmkmfyq4sl6r5mnhvxijiuhhtlxqkw4x4v7sye5v7255cf54',
    'bafyreiasvgp3nyj2lyerapcz5ecn7daror3e6rsbekinry5g2kvhfemfau',
    'bafyreifuvcgjsd4dxhexnoxivpdygnmyuxur3so5paqtivmqr3jabldlne',
    'bafyreicliirufvuqnl3jevhshy3iqdmpztkx7sbeowtklkm4bo5hxotyb4',
    'bafyreiabzmyxdrxbbivkqedpce4m45cgvygkx34wv3cdfmrpsdfkxl4l3u',
    'bafyreieaeksd2qwamzdfaursikjswoieobkfrnzkrjli7jl2fncosos4su',
    'bafyreiflhiyjyssdmbl5ggc3locenqsgj7vf3ryfoodrtqdoweazkjew2q',
    'bafyreidsyyugsqybwwjpj4w7ik6tvvf4bdavqwlbscec5naasths2wi42i',
    'bafyreifdebvth6glbyswwd6mayunbwcnwge7fpczh4gfywdhhz565tyn4q',
    'bafyreifusbyckmcddb3iaz27ursll6r3p746cu33fsmndjgqsyfrkceuri',
    'bafyreifjzk3blop6gkikcwy7ubmuekkmo4bphhkkog6hbgbs6etdny5ugi',
    'bafyreifmptq6xme6oxd4vyihgf4hasmaxzuizeml5xyfvaznfevgf34fla',
    'bafyreigmrytzzohihwlgm3ninu2ekqimuskgeagiog6kd5uuuqunyebosi',
    'bafyreicgq6hleythsqwefrvpablmfjrjznanwa6bfwid2dxp3lmmatpsfq',
    'bafyreib5tbelhu22mzxaw7h2sjadprecgvawktsekwblkdxffvzb7opxz4',
    'bafyreihzbvh7e45ypgbkckym3dupwmyqcpbpsig3xulleq6efyrqy6t6lq',
    'bafyreiezeivkic4e4hbivqa6mp7p6mxtumxe6s7cm32kzovea66wir3vwu',
    'bafyreiadsm6catfbspw7erqobdzu4gy7mx4x3qxf4npieruy5iia4o6wsu',
    'bafyreiflpj4ark6pmbudfyllbjykv25tvnny5g2nquhovnk6vwrjgmlyti',
    'bafyreideyh3pmo4wcorfiys4kayalreieimnxrrnm3xz7hi6le4yvam3qi',
    'bafyreihjjr4skqmam6g5m6hfr4hdgjj24nhmexefcsyxpponfrs6sz6aoi',
    'bafyreiffnlgousa4di5beybw2xo7vnz4yatlr26cstmoxfrhqm7qaxhznq',
    'bafyreifosnqmdtfxi6e3gj2wejfdcbgxlcprmoakst2czxekktp56tydui',
    'bafyreiec7taetkqr4634ya5onax6jpwfplsw5m5cbwsewtottcc6lmmnjm',
    'bafyreiarzheemxha34roseskqur7ykj5s2baa5o5vc6ow5zt4cv7gwxa54',
    'bafyreihuxt7cevtpanxy5mld5bu46vyippn2sw4mgkjjkifj6vbosln7cq',
    'bafyreibuqotvzpwxbtosje7v5hejfpygmbcyenkeshbrgyufnik5mbfadm',
    'bafyreiblzo334amwaevpz4tvlvgjxxgppjcbcgxo5wnrmi35m3sdnth64q',
    'bafyreifkne7n6yafht2nbfbckf5crala2crnifkfxa3su6rpvqxdpeo2aa',
    'bafyreiglbwqvn2vsgabdqy2pg7zzye2tgfivfsip6nihfcvu6fvgbngbri',
    'bafyreia7zmyiscfkknarwv46su4sve3nomlrwlg63vu5pempbmi2gochw4',
    'bafyreiasgn5xzzec7cxq365dsbwitjjetticjlhtslym22kh3pj6c6wf2a',
    'bafyreie7ywjv47dhrqjl6qthzn6enehijn62ulms27dc5x4ywwareasrsm',
    'bafyreieatrkxcq7i3d7uirwe5eppexr5o3mscmreks2df35ymmyxjdtg6q',
    'bafyreieihb25qtop3hcvslf7ubxhmlq2sueeez2pz453g6fyq72y6g4maa',
    'bafyreibzvrhhlqfwoq6f7gqq53zlbwztkswc5qlhjh6knmycaulbzyfbma',
    'bafyreidmj7tqtzrvllturt3rsfyyp5kcqo5iifom323fx4nszb2bm72p2u',
    'bafyreickuia45nrby3jmgmdm56cnii2ummw4c2madgkiovhdrxeca55rcm',
    'bafyreiamavypwvud5bci5w2zjulrm5gtuamcrbuzo6jx72uvg36ylzu2gu',
    'bafyreih5g7v4hdzgfyixcao7rxtjsrnsxfysi3txhlpzoa573nvhaqnwga',
    'bafyreid2zkibyzpyrbn7idijdmjsnqetz47zhrbg3z3evicqfcdettrp44',
    'bafyreiavuot6r46fi7l5l6yzvhht63pyba3j7jujlmjgb2l36yedctsrja',
    'bafyreihojhsu4afgfaikcrevbemwe3q53dactzydjknfbcjfdd25aag7qe',
    'bafyreigze5lyiwmy7ksyuduaqibrkhdo5bmthxn7co33zrk5n5rykgdroa',
    'bafyreidjlcadt43haogameuzcw3y3in3z6g2ao6qykceletf3ltgsljlle',
    'bafyreifsygjqkq5naxoxbl4xi56otqh7fwpzdukj6lgxlssbidhj5hcpzy',
    'bafyreigi4vor3on5nr63lcqcvbz7gewlrqrhwcndy6eipiujv5dmbvzubu',
    'bafyreibk2wgcx5qlx4bp4gwpmlbo4yqgut6is25gsms5lqa3xfrtu3tuxq',
    'bafyreidgncsjgfurbps65sccq2ifhzpd73mpn7c6tk55nmrpejui6kok6a',
    'bafyreiatmh5cld3rhsxovzxridkbczduke4d24xhgmsyqdcmdfnkyhinqy',
    'bafyreiceygmyvzmtc6v6jn4ffn7apv4j3lggjieddt6i2bpbaxd2odb5gm',
    'bafyreieuiviylgq3sxm5qvasfhkoij67vex2o3yn6s6zbrdld3xx5l2d34',
    'bafyreie4biovb6ndoegn56bkjjyol3c2uey6w6izonqvlmjv7sr4ar23nq',
    'bafyreicx5f6kz4pdsbjpdeft2eeginhecpngyfkchtzl2x5qlfhh5fjfwm',
    'bafyreihogk43xe7glabvgqjw3voqx77bhr6e5ffpqb4wfxp2vbj4snxova',
    'bafyreibbyqecnjfupx6mp7zh2qft2crww52zj6b6bghaan2zbyafj7q7vy',
    'bafyreigogfauedpr2xgfqrg4fwfmvcjb6gyvpmxoqfoqthimy3dkwje7rq',
    'bafyreicajzi2lm2ctibxbss5gik4zrznt6lzwuv6kfnxxbppbpetwzc5mm',
    'bafyreicqrz4olkhvtfm2jys4ysoystyzktjybyuii7nwwdy2pzy5piy5qq',
    'bafyreib5pp2kkbnbbxlohitcshgzccyz5w5l5wzxqwenrge3x67lifci7a',
    'bafyreigqut7vjicra7q6gefacw4yrcn76eeqx2le7eyezvxtlsdutmo7da',
    'bafyreies4bc7qzv3qw2yd7hpc2fefdm2lcqxiuzdapc3k7d6wlkf3fjkme',
    'bafyreiamvejtqxodzrdmg5e24dvgvvs6mfkma7x34tgku5afngfys5nxk4',
    'bafyreie2estlrt4oekwjl3gac32bqbemrvj6hvt7n6yhjb2zjpta23vop4',
    'bafyreidhtxlv6qhcjdcqlk6lcg7jrgrsthguzyciwodoizdawl7lyxevpy',
    'bafyreibvuai7dufyna6kqo443p7nhqtr65csvfgheig7w4ya3ujpq2qg5u',
    'bafyreiewwqwgbvfl6nc2b2n5uabam2fgzolk37wpi4f3wnbl6qg4n3c2bi',
    'bafyreif4w3gr7fiqe4t23njm6z7sqsmmhjdzjjb3gqh73con2w3ixcucvq',
    'bafyreibs5nbfqw723krhwg45txseiyssd3iavsb2qs3vdyiad5miehjzue',
    'bafyreieqph4aiczlksj466sfruxchdcl4fqrjrtxl6gpdt6dv6q3y52yzm',
    'bafyreibuq7isqcuer6apxrc6f6vlrg7q2afqkuc7f2vhfl2imjs7kd75ue',
    'bafyreifbsyqahv6vjdokvxzrnfm26uzdudd6425vabdlov5cxrd6rfskd4',
    'bafyreibmrt6hp3grm72v7u6gwdrdfie3guisw3sjpjqacewlzjilimggbm',
    'bafyreibun7lvuyfhph6ldimtl2cgrpjis2vwwig67hdlbgcoq3tmg3ppjq',
    'bafyreigerpevogfqtbueubblj6h4bdvneuu52gu5ji3jlheuadzpzqfjcm',
    'bafyreidrzklb4jcoyk6ysh4xrim5g7k7lk7hd2l3wiykc33f4i4qjloscy'
  ];
    
  constructor() ERC721("We Like The Rocks", "WLTR") {}

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(tokenId < 100, "0 to 99");

    string memory baseURI = _baseURI();
    string memory tokenHash = _hash(tokenId);
    return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenHash, "/metadata.json")) : "";
  }
  
  function _baseURI() internal view virtual override returns (string memory) {
    return "ipfs://";
  }
  
  function _hash(uint tokenId) internal view virtual returns (string memory) {
    return hashes[tokenId];
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
  
  function createWarden() public {
    address warden = address(new RockWarden());
    require(warden != address(0), "Warden address incorrect");
    require(wardens[_msgSender()] == address(0), "Warden already created");
    wardens[_msgSender()] = warden;
  }
}