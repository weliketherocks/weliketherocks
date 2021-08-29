// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

/******************************************/
/*           IERC165 starts here          */
/******************************************/

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/******************************************/
/*           ERC165 starts here           */
/******************************************/

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

/******************************************/
/*          Strings starts here           */
/******************************************/

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

/******************************************/
/*          Context starts here           */
/******************************************/

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/******************************************/
/*           Ownable starts here          */
/******************************************/

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

/******************************************/
/*          Address starts here           */
/******************************************/

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/******************************************/
/*       IERC721Receiver starts here      */
/******************************************/

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

/******************************************/
/*           IERC721 starts here          */
/******************************************/

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

/******************************************/
/*       IERC721Metadata starts here      */
/******************************************/

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

/******************************************/
/*           ERC721 starts here           */
/******************************************/

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}

/******************************************/
/*         EtherRock starts here          */
/******************************************/

interface EtherRock {
  function sellRock (uint rockNumber, uint price) external;
  function giftRock (uint rockNumber, address receiver) external;
}

/******************************************/
/*         RockWarden starts here         */
/******************************************/

contract RockWarden is Ownable {
  function claim(uint256 id, EtherRock rocks) public onlyOwner {
    rocks.sellRock(id, type(uint256).max);
    rocks.giftRock(id, owner());
  }
}

/******************************************/
/*       Original EtherRock Wrapper       */
/******************************************/

// "
// This is a revised version of the original EtherRock contract 0x37504ae0282f5f334ed29b4548646f887977b7cc with all the rock owners and rock properties the same at the time this new contract is being deployed.
// The original contract at 0x37504ae0282f5f334ed29b4548646f887977b7cc had a simple mistake in the buyRock() function. The line:
// require(rocks[rockNumber].currentlyForSale = true);
// Had to have double equals, as follows:
// require(rocks[rockNumber].currentlyForSale == true);
// Therefore in the original contract, anyone could buy anyone elses rock for the same price the owner purchased it for (regardless of whether the owner chose to sell it or not)
// "

contract OriginalEtherRock is ERC721 {
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
    'bafyreidrzklb4jcoyk6ysh4xrim5g7k7lk7hd2l3wiykc33f4i4qjloscy',
    
    // negative hash space
    
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
    
  constructor() ERC721("Original EtherRock", "WLTR") {}
  
  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    string memory baseURI = _baseURI();
    string memory tokenHash;
    
    // Mirrored hash space for negative tokenIds
    if (tokenId > 57896044618658097711785492504343953926634992332820282019728792003956564819967) {
        tokenHash = _hash(((type(uint256).max - tokenId + 1) % 100) + 100);
    } else {
        tokenHash = _hash(tokenId % 100);
    }
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
