Welcome to Lifie!

This is a fantastic app which lets you post your life in cool ways.

/How to use/

1. Login with provided TestUserA or TestUserB. If you have logged on, you can find your current role by clicking on the fifth(rightmost) navigation bar.

2. Five nagivation views, not all implemented:

    2.1 Playground
    This view will present 15 most recent posts of all playersfrom FireBase database. The default present mode is "cylinder", in which you can swipe letf and right to let posts rotate. You will see another tab bar above the navigation bar, containing 5 buttons to change the ways to present the posts.
    Each post consists of 4 parts: header, body, action bar and comments area. You can swipe up and down to see the entire post. Action bar and comments area haven't been implemented, but you can still click on them to see what happens.
    
    2.2 Explore
    This view has not been fully implemented. So far, it has a search bar with no real search function and a collection view to present posts in a traditional way. You can click photos to see posts' details just as what have been shown in Playground
    
    2.3 New post
    This view let users create a new post by choosing a picture from album and entering some texts. The share button is enabled(change color from grey to black) only if you have chosen a photo. After successfully sharing a post, you will be redirect to Playground and can see your new post.
    
    2.4 Notification
    This view is used to notify users if someone has hit like button on his posts or follows him. But those follow-related functions are not available yet, so there is just a "No Notifications" message here.
    
    2.5 Profile
    Here you will see your profile image, name and other profile information. The collection view below show only your posts, but not others, you can also click on them.
    On the upper right corner is a setting button, which enables users to logout. Edit profile function is not available.
    Then you can switch to another user to play around with it.
    
/Implementation/

1. I use Pods to install Firebase framework and save all data in firebase, so that when testing, you will see these 2 pre-defined test users as well as some posts. Photos are stored as URL in Firebase storage. Database related class are all singleton classes
2. Carousel view is built based on iCarousel framework, with small changes to fit in this app. 
3. I really take advantages of delegate pattern. Most of small elements which may be reused has their own classes, as well as a delegate. The view controllers who contains the elements will conform to the delegate and take part of the responsibilities to handle actions. You may want to see "PostView" class, which is used to present a post view and contains 4 cells, each of which has it own class and corresponding delegate.

/Other/

There maybe a warning saying that Appirater implements a deprecated method. Appirater is installed by Pods and this warning still exists after updating Pods. This file is read-only so I can not modified.

I realize the goal to create an app, let users release posts, and then present them in a rotatable way. There are still a bunch of stuff which can be added but are unavailable yet because of time limitation. The amount of code so far has been much larger than I expected for a one-person team. However, I do think I have built a pretty good structure and am looking forward to continue with it afterwards.
