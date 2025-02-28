program auction.aleo {
  
    record Bid {
        owner: address,
        bidder: address,
        amount: u64,
        is_winner: bool,
    }


    record Auction {
        owner: address,
        min_bid: u64,
        end_time: u64,
        highest_bid: u64,
        highest_bidder: address,
    }

    
    function get_highest_bid(new_amount: u64, current_highest: u64) -> u64 {
        if new_amount > current_highest {
            return new_amount;
        }
        return current_highest;
    }

    
    function get_highest_bidder(new_amount: u64, current_highest: u64, new_bidder: address, current_bidder: address) -> address {
        if new_amount > current_highest {
            return new_bidder;
        }
        return current_bidder;
    }

    transition place_bid(bidder: address, amount: u64, current_time: u64, owner: address, min_bid: u64, end_time: u64, highest_bid: u64, highest_bidder: address) -> (Bid, Auction) {
        
        assert_eq(self.caller, bidder);

        
        assert(amount >= min_bid);

        
        assert(current_time < end_time);

        
        let bid: Bid = Bid {
            owner: owner,
            bidder: bidder,
            amount: amount,
            is_winner: false,
        };

        
        let new_highest_bid: u64 = get_highest_bid(amount, highest_bid);
        let new_highest_bidder: address = get_highest_bidder(amount, highest_bid, bidder, highest_bidder);

       
        return (
            bid,
            Auction {
                owner: owner,
                min_bid: min_bid,
                end_time: end_time,
                highest_bid: new_highest_bid,
                highest_bidder: new_highest_bidder,
            }
        );
    }

    
    transition resolve(auction: Auction, current_time: u64) -> Bid {
        
        assert_eq(self.caller, auction.owner);

       
        assert(current_time >= auction.end_time);

        
        return Bid {
            owner: auction.owner,
            bidder: auction.highest_bidder,
            amount: auction.highest_bid,
            is_winner: true,
        };
    }
}