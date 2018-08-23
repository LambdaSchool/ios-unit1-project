# Books

## Overview

You will be building a project that spans the whole week. The format is a bit different than you're used to thus far in the course. The instructions for this project are more like a Sprint Challenge in that they are much more sparse than a normal project. 

You are to treat this week as if you are building this application at a company and the instructor is your client. The project managers (including section lead) will be your main support throughout the week.

The main objective of this week is to develop the MVP feature set listed below using the technologies you have learned here at Lambda School thus far.

## Instructions

This project is open-ended, meaning after you finish the requrements listed below, you will spend the remaining time implementing extra features below and/or you may implement your own feature(s) that you come up with. If you want to implement a feature of your own, run the idea through a PM or your section lead to have them approve it.

This project uses the Google Books API. Take the time now to read [this page](https://developers.google.com/books/docs/v1/getting_started) as it will explain many things including how the API works in general, some requirements in order to use it, its basic data structure, and the operations you can perform using it. The better you understand the API beforehand, the faster you will be able to use it efficiently. 

### Requirements

You must implement every one of these requirements in your application:

- Your model object that represents a volume must have at the very least the following properties:
    - Its title
    - An image representing its cover
    - Your review of the book. This will not be a part of the API.
    - Whether you have read the book or not. This will not be a part of the API. We know there is a bookshelf pre-created to show the books you have read)
- Search for volumes and display them to the user. 
- List all of your bookshelves
- Insert, update, and delete volumes in a bookshelf. (On the API side)
- Move books between bookshelves.
- Bookshelf and volume information must be persisted using Core Data and synchronized with the API.

### Extra Requirements

Note that once you have finished the requirements, you are not finished with the project. You are expected to implement extra features. You just have the liberty to choose which features you'd like to implement. The following are simply ideas that you could implement once you finish the requirements. Feel free to be creative with this though; if you have other ideas for features you'd like to implement, check with a PM (simply to make sure it's feasable) and have them approve it. 

These extra requirements (or the ones you come up with) are not necessarily things you have learned throughout the course. Again, treat this as if your client wants a feature that you don't know off the top of your head how to implement. How will you go about learning how to make the feature?

A few ideas are as follows:

- When you mark a volume as read, add it also to the pre-made "Have read" bookshelf. Allow for marking a volume as unread and remove it from the bookshelf as well.
- Share a link to a volume (there is one to the Google Play store in the JSON), or your review of it to Twitter, Facebook, etc.
- Find the volume on Amazon and open it in the Amazon app, or on a web browser.

## Commit History

It is essential that you get in the habit of committing your code often. This will be helpful both for yourself if you ever need to go back to old code for a variety of reasons, and also for the benefit of those you are working with. 

**Be committing regularly as it makes sense to do so.** There is no set amount of time that should happen or amount of code written between commits; simply use your best judgement. A good rule to follow is if what you've done can't be summarized in about 50 characters, you **may** have gone too long before committing.

Your PMs will be checking and making sure you are committing regularly, with clear commit messages.
