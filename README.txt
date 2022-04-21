
Huge thanks to the reddit r/Solidity community for helping me with the safety. Credits to u/marco-at-paladin wholight-audited this contract for me.

Please use only for fun.
As it comes, this type of "blind" gamble is not possible in the blockchain (At least not this style). From the fact that every dataon blockchain is public, it is imposible for me to hide data like 'pool' size or 'highest stake'. So I would not recommend using this contract as a true gambling platform.

HardcoreGamble is an ultra high-risk gambling platform.
!Testing from command line requires Brownie framework!
It is yet not finished, please feel free to propose some changes (my main focus might be the safety). 
Some tests can be done from folder "tests" using >>brownie test

The rules are:
    * The winner will be always the one who put the biggest amount of ether into the pool
    * No one knows how much is in the pool, and how big is the pool (for the sake of testing 
    only creator can get that information)
    * Each participant can bid only once (I don't know if It will not change)
    * The game ends when there are at least 3 participants and:
        option 1) If the highest bid was not bigger than the rest of the pool at the moment of biding
        than the game ends when nobody puts higher bid and: 
        
        Pool > (PoolJustAfterHighestBid - HighestBid)*2

        example: POOL: 2, 3, 4, 5    = 14
                =>BID(10)   10=HighestBid  POOL = 14+10 = 24
                =>BID(3)    POOL = 24+3 = 27    27>(24-10)*2  27>28 FALSE: GAME CONTINUES
                =>BID(4)    POOL = 27+4 = 31     31>28 TRUE: GAME ENDS player who bid 10 Wins!
        
        option 2) If the highest bid was bigger than the rest of the current pool than the game ends
        when nobody puts a higher bid and:

        Pool - HighestBid > HighestBid

        example: POOL: 2, 3, 4, 5    = 14
                =>BID(18)   18=HighestBid  POOL = 14+18 = 32
                =>BID(2)    POOL = 32+2 = 34    34-18>18  16>18 FALSE: GAME CONTINUES
                =>BID(4)    POOL = 34+4 = 38    38-18>18  20>18 TRUE: GAME ENDS player who bid 18 Wins!
                
                
                
