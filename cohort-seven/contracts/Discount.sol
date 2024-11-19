// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
contract Discount is Ownable {
    enum DiscountType { NONE, FIXED, PERCENTAGE }

    struct DiscountDetails {
        DiscountType discountType;
        uint256 value; // For FIXED, this is the fixed discount amount. For PERCENTAGE, this is the maximum percentage discount (e.g., 20 for up to 20%).
    }

    DiscountDetails public discountDetails;
    LoyaltyProgram public loyaltyProgram;

    event DiscountSet(DiscountType discountType, uint256 value);

    /**
     * @notice Sets the loyalty program contract
     * @param _loyaltyProgram Address of the LoyaltyProgram contract
     */
    function setLoyaltyProgram(address _loyaltyProgram) public onlyOwner {
        loyaltyProgram = LoyaltyProgram(_loyaltyProgram);
    }

    /**
     * @notice Sets a discount (either fixed or percentage)
     * @param _discountType The type of discount (0: NONE, 1: FIXED, 2: PERCENTAGE)
     * @param _value The discount value (fixed amount or maximum percentage)
     */
    function setDiscount(DiscountType _discountType, uint256 _value) public onlyOwner {
        require(
            _discountType == DiscountType.NONE || _value > 0,
            "Invalid discount value."
        );
        if (_discountType == DiscountType.PERCENTAGE) {
            require(_value <= 100, "Percentage discount cannot exceed 100.");
        }

        discountDetails = DiscountDetails({
            discountType: _discountType,
            value: _value
        });

        emit DiscountSet(_discountType, _value);
    }

    /**
     * @notice Gets the discounted price based on the set discount and user points from the loyalty program
     * @param _originalPrice The original price of the item
     * @param _user Address of the user
     * @return The discounted price
     */
    function getDiscountedPrice(uint256 _originalPrice, address _user)
        public
        view
        returns (uint256)
    {
        if (discountDetails.discountType == DiscountType.NONE) {
            return _originalPrice;
        } else if (discountDetails.discountType == DiscountType.FIXED) {
            return _originalPrice > discountDetails.value
                ? _originalPrice - discountDetails.value
                : 0;
        } else if (discountDetails.discountType == DiscountType.PERCENTAGE) {
            uint256 userPoints = loyaltyProgram.getUserPoints(_user);
            uint256 percentageDiscount = userPoints > discountDetails.value
                ? discountDetails.value
                : userPoints; // Points cap discount
            return _originalPrice - (_originalPrice * percentageDiscount / 100);
        }
        return _originalPrice;
    }
}
