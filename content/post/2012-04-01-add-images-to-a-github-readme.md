+++
title = "Add images to a GitHub readme"
slug = "2012-04-01-add-images-to-a-github-readme"
published = 2012-04-01T19:32:00+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2012/04/add-images-to-github-readme.html"
+++
Today I wanted to add some screenshots to a GitHub readme for the sake
of documenting. While this wasn't particularly hard, I do had to iterate
a few times before I got it right.  
  
### Hosting the images  
  
You could simply add the images to your repository and reference them
using the raw url's, but this isn't very efficient. Using this method,
every request needs to go through GitHub's application layer. It's far
better to make use of [GitHub Pages](http://pages.github.com/), a
feature purely designed to publish web content. I also like how you're
not polluting the repository this way.  
  
### Referencing the images  
  
I'm using the - oh so beautiful and simple - [markdown format](http://daringfireball.net/projects/markdown/syntax) for most of my readme's. The syntax for embedding images looks like this.  
  
`[My image](username.github.com/repository/img/image.jpg)`  
  
I hope this post fills in the void I stumbled upon when googling for
useful pointers earlier today.
