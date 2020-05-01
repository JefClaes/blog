+++
title = "Designing entities: immutability first"
slug = "2013-04-07-designing-entities-immutability-first"
published = 2013-04-07T17:35:00+02:00
author = "Jef Claes"
tags = [ ".NET", "Refactoring", "DDD", "Ramblings",]
+++
The first year I wrote software for a living I spent my days mostly
writing forms over data applications; most of my efforts were wasted
just trying to make things work using ASP.NET and the Webforms engine.
It was only after a year and graduating from the School of Hard Knocks
that I learned there is a lot more to building clean and maintainable
software than knowing the ins' and outs' of a proprietary UI
technology.  
  
One of the habits I have adapted over time, is designing new entities as
immutable objects first, and to go from there. I believe this helps me
to make more deliberate design decisions, leading to better designs.  
  
Allow me to demonstrate this using a customer entity - I know this is
cliché, but I have a hard time coming up with original examples.  
  
**A constructor**  
  
This one might sound rather obvious, but you would be surprised how many
classes don't have the decency of a simple constructor, especially since
C\# introduced [object
initializers](http://msdn.microsoft.com/en-us/library/vstudio/bb384062.aspx).
While object initializers definitely look good, they make your code
harder to maintain; classes don't communicate what they need to get by,
nor do they get the opportunity to protect their invariants as early as
possible.  
  
Like I said, I design my classes to be immutable from the start; after
initialization they can't be modified. I'm not even exposing any state
for now.

    public class Customer
    {
        public Customer(
            Guid id,
            string firstName,
            string lastName,
            string street,
            string city,
            string country,
            DateTime birthdate,
            decimal balance)
        {
            FirstName = firstName;
            LastName = lastName;
            Street = street;
            City = city;
            Country = country;
            BirthDate = birthdate;
            Balance = balance;
        }

        public Guid Id { get; private set; }

        private string FirstName { get; set; }

        private string LastName { get; set; }

        private string Street { get; set; }

        private string City { get; set; }

        private string Country { get; set; }

        private DateTime BirthDate { get; set; }

        private decimal Balance { get; set; }
    }

**Comparing identities**  
**  
**An entity is always unique within a system; it has an identity. To
encapsulate comparing two entities, and to avoid repeating myself, I
always override the Equals and GetHashCode methods. We're not guided
into doing this by our object's immutability though, but by common
sense.

    public override bool Equals(object obj)
    {
        if (obj == null || GetType() != obj.GetType())
            return false;            

        var other = obj as Customer;
           
        return Id == other.Id;
    }

    public override int GetHashCode()
    {
        return this.Id.GetHashCode();
    }

**Defaults**  
**  
**When a new customer is created, its balance is still empty. The
constructor is the perfect place to initialize this default.

    public Customer(
        Guid id,
        string firstName,
        string lastName,
        string street,
        string city,
        string country,
        DateTime birthdate)
    {
        FirstName = firstName;
        LastName = lastName;
        Street = street;
        City = city;
        Country = country;
        BirthDate = birthdate;
        Balance = 0;
    }

**Protecting invariants**  
**  
**The next thing I'll do is use the constructor to guard for arguments
that don't satisfy my objects invariants. This way we guarantee that the
object can never be initialized with an invalid state; avoiding a bunch
of trouble along the way.  
  
We expect a customer to have a first name, last name, street, city and
country which isn't empty. We also expect its birth date not to be in
the future.

    public Customer(
        Guid id,
        string firstName,
        string lastName,
        string street,
        string city,
        string country,
        DateTime birthdate)
    {
        Guard.ForNullOrEmpty(firstName, "first name");
        Guard.ForNullOrEmpty(lastName, "last name");
        Guard.ForNullOrEmpty(street, "street");
        Guard.ForNullOrEmpty(city, "city");
        Guard.ForNullOrEmpty(country, "country");
        Guard.ForDatesInTheFuture(birthdate, "birthdate");

        Id = id;
        FirstName = firstName;
        LastName = lastName;
        Street = street;
        City = city;
        Country = country;
        BirthDate = birthdate;            
        Balance = 0;
    }

    public class Guard
    {
        public static void ForNullOrEmpty(string value, string desc)
        {
            if (string.IsNullOrEmpty(value))
                throw new NullReferenceException(desc);
        }

        public static void ForDateInTheFuture(DateTime value, string desc)
        {
            if (value > DateTimeProvider.Now())
                throw new ArgumentException(
                    string.Format("{0} can't be a date in the future.", desc))
        }
    }

**Composition and extracting value objects**  
**  
**I'm fairly confident that every self-respecting programmer is annoyed
by the fact that the obvious concepts name and address haven't been
extracted yet. Especially since that bloated constructor is all up in
your face. Let's go ahead and extract two value objects: name and
address.

    public class Customer
    {
        public Customer(
            Guid id,
            Name name,
            Address address,
            DateTime birthdate)
        {
            Guard.ForNull(name, "name");
            Guard.ForNull(address, "address");
            Guard.ForDateInTheFuture(birthdate, "birthdate");

            Id = id;
            Name = name;
            Address = address;
            Balance = 0;
        }

        public Guid Id { get; private set; }
        
        private Name Name { get; set; }

        private Address Address { get; set; }

        private DateTime BirthDate { get; set; }

        private decimal Balance { get; set; }
    }

    public class Name
    {
        public Name(string first, string last)
        {
            Guard.ForNullOrEmpty(first, "first name");
            Guard.ForNullOrEmpty(last, "last name");

            First = first;
            Last = last;
        }

        private string First { get; set; }

        private string Last { get; set; }

        public string Full 
        {
            get
            {
                return string.Format("{0} {1}", First, Last);
            }
        }
        
        public override bool Equals(Object obj)
        {
            ...
        }
        
        public override int GetHashCode()
        {
            ...
        }
    }

    public class Address
    {
        public Address(string street, string city, string country)
        {
            Guard.ForNullOrEmpty(street, "street");
            Guard.ForNullOrEmpty(city, "city");
            Guard.ForNullOrEmpty(country, "country");

            Street = street;
            City = city;
            Country = country;
        }

        private string Street { get; set; }

        private string City { get; set; }

        private string Country { get; set; }
        
        public override bool Equals(Object obj)
        {
            ...
        }
        
        public override int GetHashCode()
        {
            ...
        }
    }

There, that looks better.  
  
**Tell, don't ask **  
**  
**In good OOP we tell objects what to do, we don't want to query an
object for its state and do something based on that; that would lead to
broken encapsulation and thereby more brittle code.  
  
Since our immutable object isn't exposing any state yet, we are forced
to ask ourselves why we want to expose something. This way, disregarding
"tell don't ask" becomes a deliberate choice.  
  
Let's say we want to decrease the balance, and throw an exception when
funds are insufficient. Instead of asking the customer instance and
acting on that..

    if (!customer.HasSufficientFunds())
        throw new InsufficientFundsException();

It's better to encapsulate data and behaviour, and tell it what to do
instead.

    public class Customer
    {
        public Customer(
            Guid id,
            Name name,
            Address address,
            DateTime birthdate)
        {
            Guard.ForNull(name, "name");
            Guard.ForNull(address, "address");
            Guard.ForDateInTheFuture(birthdate, "birthdate");

            Id = id;
            Name = name;
            Address = address;
            Balance = 0;
        }

        public Guid Id { get; private set; }
        
        private Name Name { get; set; }

        private Address Address { get; set; }

        private DateTime BirthDate { get; set; }

        private decimal Balance { get; set; }

        private bool HasSufficientFunds(decimal value) 
        {
            return Balance - value >= 0;
        }

        public void DecreaseBalance(decimal value)
        {
            if (HasSufficientFunds(value))
                throw new InsufficientFundsException();

            Balance -= value;
        }
    }

**Making operations explicit**  
**  
**Next thing we want to do is change the address of a customer. Since
we're not exposing the address property directly, we're also forced to
think about a useful name for the operation; I decided to name it
MoveTo. With this we make things more explicit, and thus more evident
for people who are new to the domain.

    public class Customer
    {
        public Customer(
            Guid id,
            Name name,
            Address address,
            DateTime birthdate)
        {
            Guard.ForNull(name, "name");
            Guard.ForNull(address, "address");
            Guard.ForDateInTheFuture(birthdate, "birthdate");

            Id = id;
            Name = name;
            Address = address;
            Balance = 0;
        }

        public Guid Id { get; private set; }
        
        private Name Name { get; set; }

        private Address Address { get; set; }

        private DateTime BirthDate { get; set; }

        private decimal Balance { get; set; }

        ...

        public void MoveTo(Address newAddress)
        {
            Guard.ForNull(newAddress, "new address");

            Address = newAddress;
        }
    }

    var customer = new Customer(
        Guid.NewGuid(),
        new Name("Jef", "Claes"),
        new Address("Ergens", "Antwerp", "Belgium"),
        new DateTime(1987, 10, 18));

    customer.MoveTo(new Address("Quelque part", "Brussels", "Belgium"));

**Opening up bit by bit**  
**  
**In the meanwhile our entity is no longer immutable, but we're doing a
good job of not exposing any state. If you're using the same model for
reads as you do for writes, you're going to need to expose some
properties eventually; for querying, but also for assertions. Make sure
to only expose the getters though, and to avoid violating "Tell, don't
ask" since that became a lot easier now.

    public class Customer
    {
        public Customer(
            Guid id,
            Name name,
            Address address,
            DateTime birthdate)
        {
            Guard.ForNull(name, "name");
            Guard.ForNull(address, "address");
            Guard.ForDateInTheFuture(birthdate, "birthdate");

            Id = id;
            Name = name;
            Address = address;
            Balance = 0;
        }

        public Guid Id { get; private set; }
        
        public Name Name { get; private set; }

        public Address Address { get; private set; }

        public DateTime BirthDate { get; private set; }

        private decimal Balance { get; set; }

        private bool HasSufficientFunds(decimal value) 
        {
            return Balance - value >= 0;
        }

        public void DecreaseBalance(decimal value)
        {
            if (HasSufficientFunds(value))
                throw new InsufficientFundsException();

            Balance -= value;
        }

        public void MoveTo(Address newAddress)
        {
            Guard.ForNull(newAddress, "new address");

            Address = newAddress;
        }
    }

**Summarized**  
  
By making my entities immutable from the start I am guided into adhering
to a bunch of good practices:  

-   A constructor
-   Comparing identities
-   Defaults
-   Protecting invariants
-   Composition and extracting value objects
-   Tell, don't ask 
-   Making operations explicit
-   Opening up bit by bit

  
I hope this post made some sense. I'd love to hear from you how I could
improve this process, and which process you have accustomed yourself
with over the years.
