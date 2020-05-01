+++
title = "Accidental entities - you don't need that identity"
slug = "2013-05-26-accidental-entities-you-dont-need-that-identity"
published = 2013-05-26T16:27:00.001000+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "Architecture", "DDD", "Nhibnerate",]
+++
An entity is identified by an identifier, while value objects are
identified by their value.  
  
If I make a living renting cars to tourists, I might not care the least
about the identity of the colors the cars came in. I just care about
their value; Rosso Corsa, Azurro Metallic... If I repaint the car, the
color changes, and the previous color is abandoned as a whole.  
However, if I were a car paint manufacturer, I would care a great deal
about the identity of a color. My first action might be to make up a
marketable name for the color, something that I can identify it with - a
la Burnt Sienna or Iceberg Blue. The color might have a certain
structure from the get-go, but I might experiment with the structure
along the way, while I'm still referring to it as the same color.  
  
Imagine that I'm implementing a tool to manage the car rental's fleet,
and that the CEO told me that color is one of the specifications that
seems to matter a lot to their customers. The list of available colors
is rather limited though; black, dark gray, and blue. Yet the CEO
insists on managing this collection by herself; this should avoid having
to call in another expensive consultant a few years down the road.  
  
**Color as an entity**  
  
So we define a collection of colors that will be persisted by
NHibernate. Since NHibernate, and our relational database don't play
nice without a primary key, we add an identifier to the colors.  
  
We end up with two classes; one entity that defines a color, and another
entity that defines a car. A car references a color.

    public class Car
    {
        public Car(Color color) 
        {
            if (color == null)
                throw new ArgumentNullException("color");

            Color = color;
        }

        protected Car() { }

        public virtual int Id { get; protected set; }

        public virtual Color Color { get; protected set; }

        public override bool Equals(object obj)
        {
            if (obj == null)
                return false;

            var car = obj as Car;

            if (car == null)
                return false;

            return car.Id == Id;
        }

        public override int GetHashCode()
        {
            return Id.GetHashCode();
        }
    }

    public class Color
    {
        public Color(string name, string hexadecimalNotation)
        {
            if (string.IsNullOrEmpty(name))
                throw new ArgumentNullException("name");
            if (string.IsNullOrEmpty(hexadecimalNotation))
                throw new ArgumentNullException("hexadecimalNotation");

            Name = name;
            HexadecimalNotation = hexadecimalNotation;
        }

        protected Color() { }

        public virtual int Id { get; protected set; }

        public virtual string Name { get; protected set; }

        public virtual string HexadecimalNotation { get; protected set; }

        public override bool Equals(object obj)
        {
            if (obj == null)
                return false;

            var color = obj as Color;

            if (color == null)
                return false;

            return color.Id == Id;
        }

        public override int GetHashCode()
        {
            return Id.GetHashCode();
        }
    }

    public class CarClassMap : ClassMap<Car>
    {
        public CarClassMap()
        {
            Id(x => x.Id).GeneratedBy.HiLo("10");

            References(x => x.Color);          
        }
    }

    public class ColorClassMap : ClassMap<Color>
    {
        public ColorClassMap()
        {
            Id(x => x.Id).GeneratedBy.HiLo("10");

            Map(x => x.Name).Length(30).Not.Nullable();

            Map(x => x.HexadecimalNotation).Length(7).Not.Nullable();
        }
    }

The generated schema looks like this.  
  

[![](/post/images/thumbnails/2013-05-26-accidental-entities-you-dont-need-that-identity-V1.PNG)](/post/images/2013-05-26-accidental-entities-you-dont-need-that-identity-V1.PNG)

And while this looks innocent at first, accidentally creating an entity
raises a bunch of new concerns and questions. What happens if a color is
no longer available, and the CEO wants to remove it from the collection?
Does that mean we should delete all models that came in this color? No,
those colors still exist, we're not going to repaint all the vehicles;
those colors just aren't available anymore. This hints towards a concept
that might be missing.  
  
**Fighting symptoms**  
**  
**We see the CEO heading over to the cafeteria, so we jump up, and ask
her whether it makes sense for her to mark those colors as unavailable,
instead of deleting them. After a short delay she shrugs and replies:
"Well, I could do that if that makes things easier for you." We go ahead
and model our solution to reflect this new information. 

    public class Color
    {
        public Color(string name, string hexadecimalNotation)
        {
            if (string.IsNullOrEmpty(name))
                throw new ArgumentNullException("name");
            if (string.IsNullOrEmpty(hexadecimalNotation))
                throw new ArgumentNullException("hexadecimalNotation");

            Name = name;
            HexadecimalNotation = hexadecimalNotation;
            Available = true;
        }

        protected Color() { }

        public virtual int Id { get; protected set; }

        public virtual string Name { get; protected set; }

        public virtual string HexadecimalNotation { get; protected set; }
        
        public virtual bool Available { get; protected set; }
        
        public virtual void MakeUnavailable() 
        {
            Available = false;
        }

        public override bool Equals(object obj)
        {
            if (obj == null)
                return false;

            var color = obj as Color;

            if (color == null)
                return false;

            return color.Id == Id;
        }

        public override int GetHashCode()
        {
            return Id.GetHashCode();
        }
    }

A few days later we show off what we came up with to the CEO. She looks
content with what we built over the last few days, until we show her the
user interface that manages the colors. "I'm rather busy so I often make
mistakes when I take care of these administrative tasks, could you add a
button to really delete a color from this list anyway?" This brings us
back to square one. First thing we think about is soft deleting the
colors. We could also only make it possible to remove a color if it
hasn't been referenced yet. A voice in the back of our heads keeps
telling us that we must be missing something though, and that this seems
to be harder than it should be. A few hours later, driving home after a
tough day, it becomes obvious that the CEO really thinks of a color as a
value instead of an entity, so we should really be modeling it as
such.  
  
**Color as a component**  
**  
**Luckily, NHibernate makes this pretty simple. The next day, we arrive
early at the office, and change our mapping to use a
[component](http://ayende.com/blog/3937/nhibernate-mapping-component),
so that instead of the car referencing a color, we store the value, and
lose the id.

    public class CarClassMap : ClassMap<Car>
    {
        public CarClassMap()
        {
            Id(x => x.Id).GeneratedBy.HiLo("10");

            Component(
               x => x.Color,
               m =>
               {
                   m.Map(x => x.Name).Column("ColorName").Length(30).Not.Nullable();
                   m.Map(x => x.HexadecimalNotation).Column("ColorHex").Length(7).Not.Nullable();
               });
        }
    }

  

The generated schema now looks like this; we're no longer referencing
the Color table.  
  
[![](/post/images/thumbnails/2013-05-26-accidental-entities-you-dont-need-that-identity-V2.PNG)](/post/images/2013-05-26-accidental-entities-you-dont-need-that-identity-V2.PNG)  
  
When we store a color now, it's an entity. But as soon as we put it on a
car, it's a value object. When we pull the car back out of our
persistence store, we have lost the identity. We should modify our code
so that the color's behaviour reflects these changes. We modify the
default constructor so that the object gets initialized with a default
identifier. The default constructor will get used by NHibernate when it
hydrates the object after getting it out the persistence store. We
override the Equals and GetHashCode methods so that the identifiers are
compared when there's an identity, but when the identifier isn't
hydrated, the values are compared.

    public class Color
    {
        public Color(string name, string hexadecimalNotation)
        {
            if (string.IsNullOrEmpty(name))
                throw new ArgumentNullException("name");
            if (string.IsNullOrEmpty(hexadecimalNotation))
                throw new ArgumentNullException("hexadecimalNotation");

            Name = name;
            HexadecimalNotation = hexadecimalNotation;
        }

        protected Color() 
        {
            Id = -1;
        }

        public virtual int Id { get; protected set; }

        public virtual string Name { get; protected set; }

        public virtual string HexadecimalNotation { get; protected set; }

        public override bool Equals(object obj)
        {
            if (obj == null)
                return false;

            var color = obj as Color;

            if (color == null)
                return false;

            if (Id != -1)
                return Id == color.Id;

            return Name == color.Name && HexadecimalNotation == color.HexadecimalNotation;
        }

        public override int GetHashCode()
        {
            if (Id != -1)
                return Id.GetHashCode();

            return Name.GetHashCode() & HexadecimalNotation.GetHashCode();
        }
    }

This feels off though; using one concept in two different contexts makes
things rather confusing. Is color an entity, or value object? Or does it
depend?  
  
**Separate concepts**  
**  
**We extract two explicit concepts instead; a color as a value object,
and an available color as an entity. 

    public class AvailableColor 
    {
        public AvailableColor(string name, string hexadecimalNotation)            
        {
            if (string.IsNullOrEmpty(name))
                throw new ArgumentNullException("name");
            if (string.IsNullOrEmpty(hexadecimalNotation))
                throw new ArgumentNullException("hexadecimalNotation");

            Name = name;
            HexadecimalNotation = hexadecimalNotation;
        }

        protected AvailableColor()
        {
        }

        public virtual int Id { get; protected set; }

        public virtual string Name { get; protected set; }

        public virtual string HexadecimalNotation { get; protected set; }

        public static explicit operator Color(AvailableColor value)
        {
            return new Color(value.Name, value.HexadecimalNotation);
        }  

        public override bool Equals(object obj)
        {
            if (obj == null)
                return false;

            var color = obj as AvailableColor;

            if (color == null)
                return false;

            return color.Id == Id;
        }

        public override int GetHashCode()
        {
            return Id.GetHashCode();
        }
    }

    public class Color
    {
        public Color(string name, string hexadecimalNotation)
        {
            if (string.IsNullOrEmpty(name))
                throw new ArgumentNullException("name");
            if (string.IsNullOrEmpty(hexadecimalNotation))
                throw new ArgumentNullException("hexadecimalNotation");

            Name = name;
            HexadecimalNotation = hexadecimalNotation;
        }

        protected Color()
        {
        }

        public virtual string Name { get; protected set; }

        public virtual string HexadecimalNotation { get; protected set; }

        public override bool Equals(object obj)
        {
            if (obj == null)
                return false;

            var color = obj as Color;

            if (color == null)
                return false;

            return Name == color.Name && HexadecimalNotation == color.HexadecimalNotation;
        }

        public override int GetHashCode()
        {
            return Name.GetHashCode() & HexadecimalNotation.GetHashCode();
        }
    }

This looks better. We now have two explicit concepts. An explicit
conversion allows you to get a color out of an available color, losing
the identifier.

    var availableColorOrange = new AvailableColor("Orange", "#CC3232");
    var car = new Car((Color)availableColorOrange);                    
                        
    Console.WriteLine(car.Color.Equals(new Color("Orange", "#CC3232"))); // true

**Conclusion**  
**  
**We meet up with the CEO one last time, and show her what we reworked.
When we demo how she can manage the collection of available colors by
just adding and deleting them - without caring whether one of the cars
came in that color, a smile shows up on her face; "This is exactly what
I needed, it really shouldn't be harder than this."  
  
Tools often trick us into creating entities. These accidental entities
then go on to introduce expensive coupling, introducing questions and
problems that could easily be avoided by copying values around
instead.  
  
Does your codebase contain accidental entities?  
*  
Next week: but what about the UI?*
