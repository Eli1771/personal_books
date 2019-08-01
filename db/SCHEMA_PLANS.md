Book
  SEARCH PARAMS
  - title
  - author
  - topic
  - status (checked in/checked out) <-- probably add later
  LOCATION
  - case_id
  - shelf_id
  - room_id (through case) <-- don't need this one

Case
  - room_id
  - name
  - description (optional)
  - shelf_count

Room
  - user_id
  - name  

User
  - username
  - password
