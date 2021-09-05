// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';

interface EtherRock {
  function sellRock (uint rockNumber, uint price) external;
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

contract GenesisRocksCommunity is ERC721 {
  EtherRock public rocks = EtherRock(0x37504AE0282f5f334ED29b4548646f887977b7cC);

  using Address for address;
  using Strings for uint256;

  string private _baseTokenURI;
  uint256 private _totalSupply;

  mapping(address => address) public wardens;
  
  string[] hashes = [
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
    "bafybeidqpcfb6vg3xevz3n4jyfcl5s2nftftgdqhrnuclcwrsc6wgb2g6u/99.png"
  ];
    
  constructor() ERC721("Genesis Rocks: Community Edition", "ROCKCE") {}

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(tokenId > 99, "100+");
   
    string memory image = string(abi.encodePacked(_baseURI(), _hash(tokenId % 100)));

    return string(
      abi.encodePacked(
        'data:application/json;base64,',
        Base64.encode(
          bytes(
            abi.encodePacked(
              '{"name":"',
                string(abi.encodePacked("Rock #", tokenId.toString())),
              '", "description":"',
                string(abi.encodePacked("Rock #", tokenId.toString(), " from a contract deployed on the 25th of December, 2017")),
              '", "attributes": [{ "trait_type:": "Number", "value": ', tokenId.toString(), ' }], "image": "',
                image,
              '"}'
            )
          )
        )
      )
    );
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
    require(id > 99, "100+");
    
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