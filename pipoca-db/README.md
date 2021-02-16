# 🗺️ RoadMap 
- [x] need to finish the controllers.
- [x] need to figure out how to work with coordinates and node.
- [x] if I figure out the post controller the comments and subcomments will be easy to do.
- [ ] need to learn how to make test with jest.
- [ ] need to make a documentation site for the endpoints.
- [ ] need to connect it with the app.
 </br> 
# 🔮 Upcoming features
1. A Notifications controller in order to store all the upcoming notifications.
2. A location table to be associated with the posts so we can know where they are located.
3. Need to have storage inorder to insert videos/photos to the posts/comments/sub_comments.
4. For advertising I need to create a CRUD for post with polygon this polygon will represent the radius the `business` will set so that any user that is within them bounds will see the ad. `businesses` will pay based on clicks and radius.
```sql
CREATE TABLE post_ads
id: INT,
content: VARCHAR,
links: ARRAY,
coordinates: GEOMETRY,
radius: GEOMETRY,
click_count: INT,

```

