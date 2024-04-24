# SparkLoop Takehome Asssignment - Construction Project Management Software: Cost and Progress Tracking System

the focus of this repo look to address the four main requirements of this assignment:
Implement a tracking system with the following functionality:

1. Every time a new element is added to a room, the status and total room expenditure should be tracked
2. The contractor should be able to go back to a specific day and get a snapshot of what the room (and the project) looked like
3. Similarly, the entire building's expenditure should be tracked daily (costs are aggregated at the end of each day) to monitor the total money spent against the budget
4. The total cost of the building cannot exceed its total budget 

The application in the repo is NOT a functioning application but rather focuses primarily on the create action for elements, as this is the primary transaction for the purpose of this assignment. It utilizes, rspec testing for the elements controller and for a service to handle snapshots. The spec testing is highlight that the 4 requirements were complete and would be available had the application been further developed. 

### Data Model
[![Screenshot-2024-04-23-at-5-02-55-PM.png](https://i.postimg.cc/mkbHrypc/Screenshot-2024-04-23-at-5-02-55-PM.png)](https://postimg.cc/XGzJHdb3)

# Assumptions
1. We view buildings as projects, and the term project and building are used in the prompt we viewed them as interchangeable do to the fact that their structure would be relatively similar in the data model.
2. Buildings may only have one contractor, and the contractor would be with the building through the entirety of the project.
3. Subcontractors were not included, this stays with our above principal that buildings can have only one contractor.
4. The sole purpose of this application is for the contruction of the building.
5. We were only concerned with the addition of elements to rooms. Rooms where added to buildings during their creation and were empty.
6. Elements or rooms could not be removed from rooms (this was due to the nature of having this be within the time requirement)

Explanation:
  I took a simpler approach with the datamodel, believing that scalability often benefits from a simpler approach. The prompt often goes back and forth between speaking about projects and buildings, for simplicity sake I treated them as the same. This is due to the fact that both projects and buildings would behave relatively the same. I choose to use two snapshot tables in the data model, one for building_snapshots, and one for room_snapshots. This was due to the expected size of the table given the application was to assume that there would be millions of rooms and hundreds of thousands of buildings. Indexing was used budget, costs, and status for the room and building tables because they are often the tables of interests. Along with indexing on the two snapshot tables as they are often the used in queries in tables that will be significantly large. 
  For the functionalities required, specifically the tracking of expenditures, the total_cost field in both the building and roooms tables allow for real time budget tracking against the total budget. Also the historical snapshots allow for both an end of day snapshot for every table in progress and a snapshot of past states when a element is successfully added. The simple yet comprehensive data model allows of complex queries and reporting, with large scale data.

### Implementation Details
  To start with functionality #1, element addition triggers a snahpshot handler, which creates a snapshot record upon successful creation and updates of room and building costs. This allows contractors to go back and see exactly the impact of each element addition. It also allows for the opportunity to further expand reporting by creating more robust data in the snapshot, for instance the new addition that triggers the snapshot creation. For functionality #2 there is a query method in the snapshot handler. This should return any records that are queried by the room or building id. For the basis of the project I just pulled the entire record but specific data would not be difficult to manipulate from the records pulled from the query. For functionality #3 I further utilized the snapshot table and also a asychronous sidekiq worker, along with cron job rake task to run at the end of the day. This would be a strong use case for an asychronous worker as the tables would be large and theoretically this would run for every contractor for every project that is in progress, it would update the given snapshot table while running in the background and triggered at a specific time. The #4th functionality is done by a model method in the elements model. This method update_related_costs returns a boolean, and checks the validity of the cost in relation to the budget through model relations, if the budget of either the room or the building is less then the cost it will cause the element creation to fail. One added piece that is important to mention is the treatment of creation as a transaction, for an element to be created, all checks must pass, which prevents the element from being created if it fails any requirement. 

### Technologies Used/Code Choices
   - Sidekiq was used for the asychronous job of creating daily snapshots, this was specific to reduce the load, as this theoretically would be a substantial amount of data and usage but isn't time sensitive making sidekiq a perfect candidate.
   - A rake task was used to just triger the cron job at a specific time, because the nature of running this at a given time every day, this was an easy and time effective way to set this up.
   - In order to keep with Dry principals, a snapshot handler was used, as multipe models would be using some of the code in there.
   - Postgres and a relational database were used due to the general relational structure of the data along with and postgres' ability to be scalable and its strong transaction support which is utilized even in this basic snapshot.
  - Rspec was used for testing, it provide a strong framework for comprehensive testing in rails.
  - Along with testing, I included some error handling while also trying to be thoughtful to the amount of added testing and time it would take to do this. Specifically at critical area's I felt it was necessary to include some error handling. 
  
### Future Enhancements
  - Authentication would be a necessary component to this application, as all the data would be behind a login, I chose not to include this as I felt it was better to focus on the basic structure on how to solve the 4 functionalities that were requested.
  - I also choose not to function on a front end at all, instead trying to highlight my ability to build the structure of this application. 
  - I would have added the ability to add and remove rooms, along with the functionality to remove elements from rooms.
  - I would ideally for an app this large not want to be directly touching the database, but rather have any interaction with the database done through internal API's.
  - The ability to add subcontractors and potentially laborers, which could add some many to many relationships seems like a prudent addition, but would further add to the complexitity along with increasing the time it would take to build out.
    
* ...
# takehome_sparkloop
