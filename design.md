This SDK is designed around a pipeline that transforms an SDK method call
into an HTTP request and transforms the response into an easy to use result.
Each pipeline stage is defined under the pipeline directory.

Each pipeline stage is designed to have a simple transformation on the input and/or output.
 * paginate add pagination parameters to the input and adds the returned pagination properties into the output
 * filter adds query parameters to the input for queries like name=Movie Name
 * json converts the output from a string to a Ruby Hash by parsing the string as JSON
 * response_body pulls the body from the HTTP response and ensures it is present and not empty
 * set_path adds the path information that will later be appended to the base URL
 * retry runs a retry strategy to attempt to resolve server errors
 * raise_http_errors converts the HTTP response classes into errors for 4XX and 5XX response codes
 * get_request is the final stage that makes the HTTP request

The main SDK object has methods that provide access to the API paths. These are defined under the api_paths directory.
Currently there is just `.movies` but it could be expanded to include other paths like `.books` or `.characters`
by adding new subclasses of MichaelTaylorSdk::ApiPaths::Base. These subclasses only need to define the main path used
in the API and any custom queries that abstract away complexity from the user by adding filters or combining related calls.
