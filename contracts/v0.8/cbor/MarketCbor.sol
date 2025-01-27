/*******************************************************************************
 *   (c) 2022 Zondax AG
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ********************************************************************************/
//
// DRAFT!! THIS CODE HAS NOT BEEN AUDITED - USE ONLY FOR PROTOTYPING

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import "solidity-cborutils/contracts/CBOR.sol";

import {MarketTypes} from "../types/MarketTypes.sol";
import "./BigIntCbor.sol";
import "../utils/CborDecode.sol";
import "../utils/Misc.sol";

/// @title FIXME
/// @author Zondax AG
library WithdrawBalanceCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;
    using BigIntCBOR for BigInt;
    using BigIntCBOR for bytes;

    function serialize(MarketTypes.WithdrawBalanceParams memory params) internal pure returns (bytes memory) {
        // FIXME what should the max length be on the buffer?
        CBOR.CBORBuffer memory buf = CBOR.create(64);

        buf.startFixedArray(2);
        buf.writeBytes(params.provider_or_client);
        buf.writeBytes(params.tokenAmount.serializeBigInt());

        return buf.data();
    }

    function deserialize(MarketTypes.WithdrawBalanceReturn memory ret, bytes memory rawResp) internal pure {
        bytes memory tmp;
        uint byteIdx = 0;

        (tmp, byteIdx) = rawResp.readBytes(byteIdx);
        ret.amount_withdrawn = tmp.deserializeBigInt();
    }
}

library GetBalanceCBOR {
    using CBORDecoder for bytes;
    using BigIntCBOR for bytes;

    function deserialize(MarketTypes.GetBalanceReturn memory ret, bytes memory rawResp) internal pure {
        uint byteIdx = 0;
        uint len;
        bytes memory tmp;

        (len, byteIdx) = rawResp.readFixedArray(byteIdx);
        assert(len == 2);

        (tmp, byteIdx) = rawResp.readBytes(byteIdx);
        ret.balance = tmp.deserializeBigInt();

        (tmp, byteIdx) = rawResp.readBytes(byteIdx);
        ret.locked = tmp.deserializeBigInt();
    }
}

library GetDealDataCommitmentCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;

    function deserialize(MarketTypes.GetDealDataCommitmentReturn memory ret, bytes memory rawResp) internal pure {
        uint byteIdx = 0;
        uint len;

        (len, byteIdx) = rawResp.readFixedArray(byteIdx);

        if (len > 0) {
            (ret.data, byteIdx) = rawResp.readBytes(byteIdx);
            (ret.size, byteIdx) = rawResp.readUInt64(byteIdx);
        }
    }
}

library GetDealClientCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;

    function deserialize(MarketTypes.GetDealClientReturn memory ret, bytes memory rawResp) internal pure {
        uint byteIdx = 0;

        (ret.client, byteIdx) = rawResp.readUInt64(byteIdx);
    }
}

library GetDealProviderCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;

    function deserialize(MarketTypes.GetDealProviderReturn memory ret, bytes memory rawResp) internal pure {
        uint byteIdx = 0;

        (ret.provider, byteIdx) = rawResp.readUInt64(byteIdx);
    }
}

library GetDealLabelCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;

    function deserialize(MarketTypes.GetDealLabelReturn memory ret, bytes memory rawResp) internal pure {
        string memory label;
        uint byteIdx = 0;

        (label, byteIdx) = rawResp.readString(byteIdx);

        ret.label = label;
    }
}

library GetDealTermCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;

    function deserialize(MarketTypes.GetDealTermReturn memory ret, bytes memory rawResp) internal pure {
        int64 start;
        int64 end;
        uint byteIdx = 0;
        uint len;

        (len, byteIdx) = rawResp.readFixedArray(byteIdx);
        assert(len == 2);

        (start, byteIdx) = rawResp.readInt64(byteIdx);
        (end, byteIdx) = rawResp.readInt64(byteIdx);

        ret.start = start;
        ret.end = end;
    }
}

library GetDealEpochPriceCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;
    using BigIntCBOR for bytes;

    function deserialize(MarketTypes.GetDealEpochPriceReturn memory ret, bytes memory rawResp) internal pure {
        bytes memory tmp;
        uint byteIdx = 0;

        (tmp, byteIdx) = rawResp.readBytes(byteIdx);
        ret.price_per_epoch = tmp.deserializeBigInt();
    }
}

library GetDealClientCollateralCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;
    using BigIntCBOR for bytes;

    function deserialize(MarketTypes.GetDealClientCollateralReturn memory ret, bytes memory rawResp) internal pure {
        bytes memory tmp;
        uint byteIdx = 0;

        (tmp, byteIdx) = rawResp.readBytes(byteIdx);
        ret.collateral = tmp.deserializeBigInt();
    }
}

library GetDealProviderCollateralCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;
    using BigIntCBOR for bytes;

    function deserialize(MarketTypes.GetDealProviderCollateralReturn memory ret, bytes memory rawResp) internal pure {
        bytes memory tmp;
        uint byteIdx = 0;

        (tmp, byteIdx) = rawResp.readBytes(byteIdx);
        ret.collateral = tmp.deserializeBigInt();
    }
}

library GetDealVerifiedCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;

    function deserialize(MarketTypes.GetDealVerifiedReturn memory ret, bytes memory rawResp) internal pure {
        bool verified;
        uint byteIdx = 0;

        (verified, byteIdx) = rawResp.readBool(byteIdx);

        ret.verified = verified;
    }
}

library GetDealActivationCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;

    function deserialize(MarketTypes.GetDealActivationReturn memory ret, bytes memory rawResp) internal pure {
        int64 activated;
        int64 terminated;
        uint byteIdx = 0;
        uint len;

        (len, byteIdx) = rawResp.readFixedArray(byteIdx);
        assert(len == 2);

        (activated, byteIdx) = rawResp.readInt64(byteIdx);
        (terminated, byteIdx) = rawResp.readInt64(byteIdx);

        ret.activated = activated;
        ret.terminated = terminated;
    }
}

library PublishStorageDealsCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;
    using BigIntCBOR for BigInt;

    function serialize(MarketTypes.PublishStorageDealsParams memory params) internal pure returns (bytes memory) {
        // FIXME what should the max length be on the buffer?
        CBOR.CBORBuffer memory buf = CBOR.create(64);

        buf.startFixedArray(1);
        buf.startFixedArray(uint64(params.deals.length));

        for (uint64 i = 0; i < params.deals.length; i++) {
            buf.startFixedArray(11);

            buf.writeBytes(params.deals[i].proposal.piece_cid);
            buf.writeUInt64(params.deals[i].proposal.piece_size);
            buf.writeBool(params.deals[i].proposal.verified_deal);
            buf.writeBytes(params.deals[i].proposal.client);
            buf.writeBytes(params.deals[i].proposal.provider);
            buf.writeString(params.deals[i].proposal.label);
            buf.writeInt64(params.deals[i].proposal.start_epoch);
            buf.writeInt64(params.deals[i].proposal.end_epoch);
            buf.writeBytes(params.deals[i].proposal.storage_price_per_epoch.serializeBigInt());
            buf.writeBytes(params.deals[i].proposal.provider_collateral.serializeBigInt());
            buf.writeBytes(params.deals[i].proposal.client_collateral.serializeBigInt());

            buf.writeBytes(params.deals[i].client_signature);
        }

        return buf.data();
    }

    function deserialize(MarketTypes.PublishStorageDealsReturn memory ret, bytes memory rawResp) internal pure {
        uint byteIdx = 0;
        uint len;

        (len, byteIdx) = rawResp.readFixedArray(byteIdx);
        ret.ids = new uint64[](len);

        for (uint i = 0; i < len; i++) {
            (ret.ids[i], byteIdx) = rawResp.readUInt64(byteIdx);
        }

        (ret.valid_deals, byteIdx) = rawResp.readBytes(byteIdx);
    }
}

library DealIDCBOR {
    using CBOR for CBOR.CBORBuffer;
    using CBORDecoder for bytes;

    function serialize(uint64 id) internal pure returns (bytes memory) {
        // FIXME what should the max length be on the buffer?
        CBOR.CBORBuffer memory buf = CBOR.create(64);

        buf.writeUInt64(id);

        return buf.data();
    }
}
