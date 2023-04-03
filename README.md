# Simple Ruby API CRUD project and site implemented the APIs

## Introduction

This project is a Ruby on Rails app to keep track of members of different teams and their projects.

* An endpoint to create/update/delete/index/show members.
* An endpoint to create/update/delete/index/show teams.
* An endpoint to create/update/delete/index/show projects.
* An endpoint to update the team of member.
* An endpoint to get the members of a specific team.
* An endpoint to add a member to a project.
* An endpoint to get the members of a specific project.
* site that use above APIs.


## Project Information

* Framework: Ruby on Rails
* Ruby version: 2.7.3
* Rails version: 7.0.3
* Database: SQLite3
* JavaScript library: jQuery 3.6.0

## How to install
* Additional Gems: `dotenv-rails`, `net-http`, `jquery-rails`, `sprockets-rails`
* Install
1. Clone the git repository and cd into it.

	`git clone https://github.com/jindev0705/team-and-project.git`

	`cd team-and-project`


2. Check Ruby version & install the dependencies.

	`bundle install`


4. Create database with migration.

    `rails db:migrate`


5. Make sure the tests succeed.

	`bundle exec rspec`


6. Run the server

    `rails s`

## Site
* Open the web browser and visit http://localhost:3000
* All request handled by calling internal APIs.
* You can test all APIs in the site.

## Models

This application has 4 models: `Member`, `Team`, `Project`, `MembersProject`.

- The `Member` model has the following attributes: `first_name`, `last_name`, `city`, `state` and `country`

  The Member's validations are the follow:

  * `first_name` and `last_name` must be present.
  * a member must belong to a team.

- The `Team` model has the following attributes: `name`

  The Team's validations are the follow:

  * `name` must be present.

- The `Project` model has the following attributes: `name`

  The Project's validations are the follow:

  * `name`.
  * a member can be optionally assigned to multiple projects.

## Routes
The application has the follow routes:

- Routes for Member APIs
  * GET 	`/api/members`: return all members as json
  * POST 	`/api/members`: create a new member
    * Parameters
      * `first_name`(required)
      * `last_name`(required)
      * `city`
      * `state`
      * `country`
      * `team_id`(required)
  * GET 	`/api/members/:id`: show a member information
  * PUT 	`/api/members/:id`: update a member information
    * Parameters
      * `first_name`(required)
      * `last_name`(required)
      * `city`
      * `state`
      * `country`
      * `team_id`(required)
  * PATCH 	`/api/members/:id`: update a member information
    * Parameters
      * `first_name`(required)
      * `last_name`(required)
      * `city`
      * `state`
      * `country`
      * `team_id`(required)
  * DELETE 	`/api/members/:id`: delete a member
  * POST 	`/api/members/:member_id/alter_team`: update team information of a member 


- Routes for Team APIs
  * GET 	`/api/teams`: return all teams as json
  * POST 	`/api/teams`: create a new team
    * Parameters
      * `name`(required)
  * GET 	`/api/teams/:id`: show a team information
  * PUT 	`/api/teams/:id`: update a team information
    * Parameters
      * `name`(required)
  * PATCH 	`/api/teams/:id`: update a team information
    * Parameters
      * `name`(required)
  * DELETE 	`/api/teams/:id`: delete a team
  * GET 	`/api/teams/:team_id/team_members`: return all members of a team


- Routes for Project APIs
  * GET 	`/api/projects`: return all projects as json
  * POST 	`/api/projects`: create a new project
    * Parameters
      * `name`(required)
  * GET 	`/api/projects/:id`: show a project information
  * PUT 	`/api/projects/:id`: update a project information
    * Parameters
      * `name`(required)
  * PATCH 	`/api/projects/:id`: update a project information
    * Parameters
      * `name`(required)
  * DELETE 	`/api/projects/:id`: delete a project
  * GET 	`/api/projects/:project_id/project_members`: return all members of a project
  * POST 	`/api/projects/:project_id/add_member`: add a member to a project


## Routes
The application includes 73 cases for unit test the project.

* /spec/requests/members_spec.rb: cases for unit test the Member APIs
* /spec/requests/teams_spec.rb: cases for unit test the Team APIs
* /spec/requests/projects_spec.rb: cases for unit test the Project APIs
