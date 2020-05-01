+++
title = "Value object obsession"
slug = "2012-09-16-value-object-obsession"
published = 2012-09-16T17:20:00+02:00
author = "Jef Claes"
tags = [ ".NET", "Refactoring", "DDD", "Ramblings",]
+++
Primitive obsession is one of the more popular (hyped?) code smells
these days.  

> Primitive obsession is the name of a code smell that occurs when we
> use primitive data types to represent domain ideas. For example, we
> use a string to describe a message or an integer to represent an
> amount of money.

The antidote is creating a value object instead of using a primitive. A
value object is an immutable object which (in its DDD definition)
carries no identity, but is compared based on the value of its
attributes.  
  
While primitive obsession is still very much the standard, newer
projects seem to regularly suffer from the other extreme; introducing
value objects as the de facto standard.  
  
For example, let's look at the implementation of this AccountNumber
class I found in the first C\# DDD Github repository.  
  
*The equality implementations are only included in the last snippet.*  

    public class AccountNumber
    {
        public AccountNumber(string value)
        {
            Value = value;
        }

        public string Value { get; private set; }
    }

**Expressing intent**  
  
It's possible that the author of this snippet thought that extracting
this object would help express intent, justifying abstraction early on.
I don't see it though. To me, it seems to be introduced prematurely,
screaming YAGNI. Clients are capable of thinking in primitives; be it
text (string), number (int)... Obvious and consistent naming can get you
far.  
  
**Composition**  
  
One of the scenarios which justify the extra boilerplate, is
composition.  
  
If we would be interested in the different parts of an account number,
we could introduce a composite object, assembling all its parts through
the constructor.  

    public class AccountNumber
    {
        public AccountNumber(
            string countryCode, 
            string checkDigits,
            string basicAccountNumber)
        {
            CountryCode = countryCode;
            CheckDigits = checkDigits;
            BasicAccountNumber = basicAccountNumber;
        }

        public string CountryCode { get; private set; }

        public string CheckDigits { get; private set; }

        public string BasicAccountNumber { get; private set; }            
    }

The account number is self contained now; its parts won't leak all over
the place.  
  
**Valid instantiation**  
  
Another valid reason to introduce a value object is when you need to
guarantee valid instances.  
  
In this example, I could guard for empty values in the constructor,
taking that responsibility/problem out of consumers' hands.  

    public AccountNumber(
        string countryCode, 
        string checkDigits,
        string basicAccountNumber)
    {
        Guard.NotEmpty(countryCode);
        Guard.NotEmpty(checkDigits);
        Guard.NotEmpty(basicAccountNumber);

        CountryCode = countryCode;
        CheckDigits = checkDigits;
        BasicAccountNumber = basicAccountNumber;
    }

**Encapsulating behaviour**  
**  
**One more important reason to use a value object, is when there is
behaviour to add; encapsulation makes for good OO. In the example below,
the Check method - which verifies the check digits - is contained by the
AccountNumber class itself, abstracting the algorithmic logic and
preventing duplication.  

    public class AccountNumber
    {
        public AccountNumber(
            string countryCode,
            string checkDigits,
            string basicAccountNumber)
        {
            Guard.NotEmpty(countryCode);
            Guard.NotEmpty(checkDigits);
            Guard.NotEmpty(basicAccountNumber);

            CountryCode = countryCode;
            CheckDigits = checkDigits;
            BasicAccountNumber = basicAccountNumber;
        }

        public void Check()
        {
            // verify checkdigits
        }

        public string CountryCode { get; private set; }

        public string CheckDigits { get; private set; }

        public string BasicAccountNumber { get; private set; }

        public bool Equals(AccountNumber other)
        {
            if (ReferenceEquals(null, other)) return false;
            if (ReferenceEquals(this, other)) return true;
            return Equals(other.CountryCode, CountryCode) && 
                    Equals(other.CheckDigits, CheckDigits) && 
                    Equals(other.BasicAccountNumber, BasicAccountNumber);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != typeof (AccountNumber)) return false;
            return Equals((AccountNumber) obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                int result = CountryCode.GetHashCode();
                result = (result*397) ^ CheckDigits.GetHashCode();
                result = (result*397) ^ BasicAccountNumber.GetHashCode();
                return result;
            }
        }

        public static bool operator ==(AccountNumber left, AccountNumber right)
        {
            return Equals(left, right);
        }

        public static bool operator !=(AccountNumber left, AccountNumber right)
        {
            return !Equals(left, right);
        }
    }

**Summarized**  
**  
**Introducing value objects instead of simple types, can add useless
boilerplate and unnecessary levels of indirection. Value objects should
arise out of certain necessity, and should not be the de facto
standard.  
  
Turn to using value objects:  

-   when they help express intent
-   for composition
-   to guarantee valid instantiation
-   to encapsulate behaviour

  

*If you disagree, please show me the light.*
