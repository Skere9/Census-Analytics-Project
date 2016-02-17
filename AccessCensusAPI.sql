CLEAR SCREEN
SET DEFINE OFF
SET SERVEROUTPUT ON

DECLARE

  vHTTPRequest  UTL_HTTP.req;
  vHTTPResponse UTL_HTTP.resp;
  vResponseText VARCHAR2(32767);

BEGIN

  DBMS_NETWORK_ACL_ADMIN.DROP_ACL 
    (
        acl         => 'www.xml'
    );

  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL 
    (
        acl         => 'www.xml'
      , description => 'WWW ACL'
      , principal   => 'STEVE'
      , is_grant    => true
      , privilege   => 'connect'
    );

  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE
    (
        acl         => 'www.xml'
      , principal   => 'STEVE'
      , is_grant    => true
      , privilege   => 'resolve'
    );

  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL
    (
        acl  => 'www.xml'
      , host => 'api.census.gov'
    );

  -- Monthly Population Estimates 
  -- by Universe, Age, Sex, Race, and Hispanic Origin 
  -- for the United States: 
  -- April 1, 2010 to December 1, 2016

  vHTTPRequest := UTL_HTTP.begin_request('http://api.census.gov/data/2015/pep/natmonthly?get=POP&for=us:*&MONTHLY=65:70&key=f1cba1702abfb72d9cf24be5d6b955c44fd253b3'
                   , 'GET'
                   , 'HTTP/1.1');

  vHTTPResponse := UTL_HTTP.get_response(vHTTPRequest);

  UTL_HTTP.read_text(vHTTPResponse, vResponseText);

  DBMS_OUTPUT.put_line(vResponseText);  


END;
/
