.. meta::
   :description: Hasura Cloud API reference
   :keywords: hasura, cloud, docs, API, API reference

.. _cloud_api_reference:

API Reference
=============

.. contents:: Table of contents
  :backlinks: none
  :depth: 1
  :local:

Introduction
------------

Hasura Cloud provides a GraphQL API to interact with the services to create
and manage your projects.

You can use any GraphQL client and use the API with the right authentication header.

Endpoint
--------

API endpoint is ``https://data.pro.hasura.io/v1/graphql``.

Authentication
--------------

Authentication is done using a Personal Access Token that you can create from
the Hasura Cloud Dashboard. You can find this option in the "My Account" section on bottom left.

Once you have the token it can be used with the header:
``Authorization: pat <token>``.

.. note::

   This token can be used to authenticate against Hasura Cloud APIs and your Hasura Cloud projects.
   Make sure you keep it secure. The token will be valid until you delete it from the dashboard.

APIs
----

Each Hasura Cloud project is backed by an API entity called "Tenant", with a
distinct "Tenant ID" which is different from "Project ID". Each Project is
associated with a Tenant. In some cases, like Metrics API, the Project ID is
used instead of Tenant ID.

List of some useful APIs:

.. contents::
  :backlinks: none
  :depth: 1
  :local:

Create a Project
^^^^^^^^^^^^^^^^

.. code-block:: graphql

   mutation createProject {
     createTenant(
       cloud: "aws"
       region: "us-east-2"
       envs: [{
         key: "HASURA_GRAPHQL_CORS_DOMAIN",
         value: "*"
       }, {
         key: "MY_ENV_VAR_1",
         value: "my value 1"
       }]
     ) {
       id
       name
     }
   }

Get Project tenant id
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: graphql

  query getProjectTenantId {
    projects_by_pk(
      id: "7a79cf94-0e53-4520-a560-1b02bf522f08"
    ) {
      id
      tenant {
        id
      }
    }
  }

Get Tenant details
^^^^^^^^^^^^^^^^^^

.. code-block:: graphql

   query getTenantDetails {
     tenant_by_pk(
       id: "7a79cf94-0e53-4520-a560-1b02bf522f08"
     ) {
       id
       slug
       project {
         id
         endpoint
       }
     }
   }

Delete a Tenant
^^^^^^^^^^^^^^^

.. code-block:: graphql

   mutation deleteTenant {
     deleteTenant(
       tenantId: "7a79cf94-0e53-4520-a560-1b02bf522f08"
     ) {
       status
     }
   }

Get ENV Vars
^^^^^^^^^^^^

.. code-block:: graphql

   query getTenantENV {
     getTenantEnv(
       tenantId: "7a79cf94-0e53-4520-a560-1b02bf522f08"
     ) {
       hash
       envVars
     }
   }

Update ENV Vars
^^^^^^^^^^^^^^^

.. code-block:: graphql

   mutation updateTenantEnv {
     updateTenantEnv(
       tenantId: "7a79cf94-0e53-4520-a560-1b02bf522f08"
       currentHash: "6902a395d70072fbf8d36288f0eacc36c9d82e68"
       envs: [
         {key: "HASURA_GRAPHQL_ENABLE_CONSOLE", value: "true"},
         {key: "ACTIONS_ENDPOINT", value: "https://my-actions-endpoint.com/actions"}
       ]
     ) {
       hash
       envVars
     }
   }

.. _api_ref_create_preview_app:

Create GitHub Preview App
^^^^^^^^^^^^^^^^^^^^^^^^^

Schedules the creation of a Hasura Cloud project with metadata and migrations from a branch of a GitHub repo.

.. code-block:: graphql

   mutation createGitHubPreviewApp {
     createGitHubPreviewApp (
       payload: {
         githubPersonalAccessToken: "<github_access_token>",
         githubRepoDetails: {
             branch: "main"
             owner: "my-org"
             repo: "my-repo",
             directory: "backend/hasura"
         },
         projectOptions: {
           cloud: "aws",
           region: "us-east-2",
           plan: "cloud_free",
           name: "my-app_name"
           envVars: [{
             key: "HASURA_GRAPHQL_AUTH_HOOK",
             value: "https://my-webhook.com"
           }, {
             key: "MY_ENV_VAR_1",
             value: "my value 1"
           }]
         }
       }
     ) {
       githubPreviewAppJobID # job ID of the preview app creation job
     }
   }



