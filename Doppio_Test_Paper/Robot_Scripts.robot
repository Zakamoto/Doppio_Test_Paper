*** Variables ***
${hostURL}  https://jsonplaceholder.typicode.com
${pathURLUser}  /users
${pathURLPost}  /posts

*** Variables ***
${apiBodyGetUser}  ${EMPTY}
${bodyPost}  {"userId": 1}

*** Keywords ***
API
    [Arguments]  ${GETorPOST}  ${SessionName}  ${PathURL}  ${Body}
    Create Session  ${SessionName}  ${hostURL}  verify=True
    ${header}  Create Dictionary  Content-type=application/json  charset=utf-8
    log  ${Body}
    ${lowerCaseGETPOST}  Convert To Lower Case  ${GETorPOST}
    ${body}   Catenate  ${Body}
    ${response}    Run Keyword And Return If	  '${lowerCaseGETPOST}'=='post'  Post Request   ${SessionName}  ${PathURL}  data=${body}  headers=${header}
    ${response}    Run Keyword And Return If	  '${lowerCaseGETPOST}'=='get'   Get Request    ${SessionName}  ${PathURL}  headers=${header}

HTTP Status Code Is 
    [Arguments]  ${Code}  ${Response}
    Should Be Equal As Numbers  ${Response.status_code}  ${Code}

Response Data Type Is application/json; charset=utf-8
    [Arguments]  ${Reponse}
    ${actualContentType}  Get Value From Json  ${Reponse.headers}  Content-Type
    Should Be Equal As Strings  ${actualContentType[0]}  application/json; charset=utf-8

Response Data Size Is
    [Arguments]  ${Expect}  ${Response}
    ${actualResponseLength}  Get Length  ${Response.text}
    Should Be Equal As Numbers  ${actualResponseLength}  ${Expect}

Response Header Is
    [Arguments]  ${Expect}  ${Response}  ${HeaderProperty}
    ${actualContentType}  Get Value From Json  ${Response.headers}  ${HeaderProperty}
    Should Be Equal As Strings  ${actualContentType[0]}  ${Expect}

Response Body Is
    [Arguments]  ${Expect}  ${Response}
    ${type}  Evaluate    type($Response._content).__name__
    ${stringResponseBody}  Convert To String  ${Response._content}
    Should Contain  ${stringResponseBody}  ${Expect}

*** Test Case ***
GET Reponse HTTP Status Code Is 200
    ${responseFromGet}  API  GET  getUserSession  ${pathURLUser}  ${EMPTY}
    HTTP Status Code Is   200  ${responseFromGet}

GET Response Data Type Is application/json; charset=utf-8
    ${responseFromGet}  API  GET  getUserSession  ${pathURLUser}  ${EMPTY}
    Response Data Type Is application/json; charset=utf-8  ${responseFromGet}

GET Response Data Type Is 5645
    ${responseFromGet}  API  GET  getUserSession  ${pathURLUser}  ${EMPTY}
    Response Data Size Is  5645  ${responseFromGet}
    
POST Response HTTP Status Code Is 201
    ${responseFromPost}  API  POST  getUserSession  ${pathURLPost}  ${bodyPost}
    HTTP Status Code Is   201  ${responseFromPost}

POST Response Header Server Is cloudflare
    ${responseFromPost}  API  POST  getUserSession  ${pathURLPost}  ${bodyPost}
    Response Header Is   cloudflare  ${responseFromPost}  Server

POST Response Request userId:1 Is userId:1
    ${responseFromPost}  API  POST  getUserSession  ${pathURLPost}  ${bodyPost}
    Response Body Is  "userId": 1   ${responseFromPost}


