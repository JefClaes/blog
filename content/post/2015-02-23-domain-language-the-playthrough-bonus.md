+++
title = "Domain Language: The Playthrough Bonus"
slug = "2015-02-23-domain-language-the-playthrough-bonus"
published = 2015-02-23T19:05:00+01:00
author = "Jef Claes"
tags = [ "ddd", "code"]
url = "2015/02/domain-language-playthrough-bonus.html"
+++
Since online gambling has been regulated in Belgium, basically each
eligible license holder has complemented their land based operations
with an online counterpart. Being such a small country, everyone wants
to secure their market share as soon as possible. The big players have
been pouring tons of money in to marketing and advertising, it's
everywhere: radio, television, (online) newspapers, bus stops,
billboards, sport events, airplane vouchers - you name it. While
regulations for land based casinos are very strict and almost
overprotective, regulations for online play are much more permissive.
This makes that online casinos can be rather aggressive acquiring new
customers.  
  
You will often see online casinos hand out free registration bonuses:
"You get 10 euro for free when you sign up, no strings attached!". This
makes it look like casinos are just handing out free cash right? We
should all know better than that though.  
  
There are always conditions to cash out a bonus. Bonuses come in
different forms and flavors and preconditions to clear them vary wildly.
The Playthrough Bonus is the favorite among players by far; it's
straightforward and requires zero investment.  
  
When you receive a Playthrough Bonus, you receive an amount of bonus
money, which can be converted to cash by wagering it a specific amount
of times. For example; you receive a Playthrough Bonus of 10 euro, which
needs to be wagered 30 times before the bonus is cleared. This means
that you need to bet 300 euro (10 euro multiplied by 30) in total to
clear the bonus and to receive what's left off your balance.  
  
So is betting the bonus amount 30 times realistic, or will you always
close your browser empty handed with nothing to show for on your
balance? The answer depends heavily on the payout rate. This percentage
represents how much of the money that goes into the casino, is returned
to players. In a formula, this is the wins divided by the bets. This
percentage is generally a lot higher than most people expect. Casinos
aim for a payout rate between 95 and 99 percent. They want to cultivate
a long term relationship with happy and social customers, not clear your
bank account as soon as you open the door. Note that the payout
percentage is an average, not all games are a smooth ride. Some players
like big wins, and big losses, while others feel more comfortable losing
small, but don't mind winning small either. Casinos also prefer a smooth
ride, especially when it comes to bonuses. They might even tweak games
to have less aggressive, more equally distributed wins when bonus money
is in play.  
  
Now let's look at how much money would be left on our balance when we
try to clear a Playthrough Bonus of 10 euro with a playthrough of 30 and
a payout percentage of 98.  
  
I defined two records (excuse my primitive obsession). First a Bonus
record that contains an amount, a balance, the total amount of bets and
a playthrough. A few functions are associated with the Bonus record;
they allow the bonus to be created, to bet, to win, to check if it still
accepts bets and to check if the bonus has been cleared. The second
record, the GameSettings, define the payout percentage and the stake of
a bet.  
  
```fsharp
type Bonus = { Amount : decimal; Balance : decimal; Bets : decimal; Playthrough: decimal; }
    with    
        static member Create amount playthrough =
            { Amount = amount; Balance = amount; Bets = 0M; Playthrough = playthrough }       
        member x.Win amount =            
            { x with Balance = x.Balance + amount }
        member x.AcceptsBet amount =
            x.Balance - amount >= 0M
        member x.Cleared =
            ( x.Playthrough * x.Amount ) - x.Bets <= 0M
        member x.Bet amount =
            match x.AcceptsBet amount with
            | true -> { x with Bets = x.Bets + amount; Balance = x.Balance - amount }
            | false -> invalidOp "Bonus can't accept bet" 
type GameSettings = { Payout : decimal; Stake : decimal; }
```

After defining these structures, I defined a function that recursively
keeps playing (bet and win) until either the bonus is cleared, or the
bonus no longer accepts bets (out of money).  

```fsharp
let rec playUntilCleared ( bonus : Bonus ) settings =          
    match bonus.Cleared with        
    | true -> bonus
    | false -> 
    (         
        let bet = settings.Stake
        let win = settings.Stake / 100M * settings.Payout

        match bonus.AcceptsBet bet with
        | false -> bonus
        | true -> playUntilCleared ( bonus.Bet(bet).Win(win) ) settings            
    )
```

When we run this function we know the answer to our question. On
average, we will clear the bonus with four euro left on our balance.  

```fsharp
printfn "%A" ( playUntilCleared ( Bonus.Create 10M 30M ) { Payout = 98M; Stake = 0.2M } )

// {Amount = 10M;
// Balance = 4.000M;
// Bets = 300.0M;
// Playthrough = 30M;}
```

When we turn down the payout to be one percent lower, we only have 1
euro left on our balance. When we turn it down even more, there won't be
anything left.  
  
Given a few parameters which should be available to you (bonus amount,
playthrough and even payout percentage), you can calculate how feasible
it is to clear a Playthrough Bonus. Unless variance is on your side, I
guess it will rarely turn out to be a lucrative grind.