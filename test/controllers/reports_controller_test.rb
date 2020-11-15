require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @global_token = '3xbDjU7wu6EQja9jBEX5XUfa'
    @docs_italia_token = '44Y4S1zK1YBVRKM71aQmgJLL'

    @report = {
      date: Time.now,
      description: 'New report',
      category: :security,
      severity: :ok,
    }
  end

  test "should get index" do
    get reports_url, as: :json

    assert_response :success
    assert_equal 1, response.parsed_body.count
  end

  test "should create report using the global token" do
    assert_difference('Report.count') do
      put(
        report_url('example.com', 'key'),
        params: { report: @report },
        headers: { 'Authorization' => authorization(@global_token) },
        as: :json
      )
    end

    assert_response 201
  end

  test "should not create report with required fields missing" do
    assert_no_changes('Report.count') do
      put(
        report_url('example.com', 'key'),
        params: { report: { description: '' } },
        headers: { 'Authorization' => authorization(@global_token) },
        as: :json
      )
    end

    assert_response 422
    assert_match(/^Validation failed:/, response.parsed_body['error'])

    assert_no_changes('Report.count') do
      put(
        report_url('example.com', 'key'),
        params: {},
        headers: { 'Authorization' => authorization(@global_token) },
        as: :json
      )
    end

    assert_response 422
    assert_match(/^param is missing/, response.parsed_body['error'])
  end

  test "should update existing report using the global token" do
    assert_no_changes('Report.count') do
      put(
        report_url('docs.italia.it', 'key-1'),
        params: { report: @report },
        headers: { 'Authorization' => authorization(@global_token) },
        as: :json
      )
    end

    assert_response 204
  end

  test "should create report using docs.italia.it token" do
    assert_difference('Report.count') do
      put(
        report_url('docs.italia.it', 'key'),
        params: { report: @report },
        headers: { 'Authorization' => authorization(@docs_italia_token) },
        as: :json
      )
    end

    assert_response 201
  end

  test "should not create report for another hostname using docs.italia.it token" do
    assert_no_changes('Report.count') do
      put(
        report_url('developers.italia.it', 'key'),
        params: { report: @report },
        headers: { 'Authorization' => authorization(@docs_italia_token) },
        as: :json
      )
    end

    assert_response 401
  end

  test "should not create report for docs.italia.it using wrong host token" do
    assert_no_changes('Report.count') do
      put(
        report_url('docs.italia.it', 'key'),
        params: { report: @report },
        headers: { 'Authorization' => authorization('no_such_token') },
        as: :json
      )
    end

    assert_response 401
  end

 test "should not create report for host with no token" do
    assert_no_changes('Report.count') do
      put(
        report_url('no.such.host.italia.it', 'key'),
        params: { report: @report },
        headers: { 'Authorization' => authorization('no_such_token') },
        as: :json
      )
    end

    assert_response 401
  end

  test "should not create report using an unmatched token" do
    assert_no_changes('Report.count') do
      put(
        report_url('docs.italia.it', 'key'),
        params: { report: @report },
        headers: { 'Authorization' => authorization('no_such_token') },
        as: :json
      )
    end

    assert_response 401
  end

  test "should destroy report" do
    assert_difference('Report.count', -1) do
      delete(
        report_url('docs.italia.it', 'key-1'),
        headers: { 'Authorization' => authorization(@docs_italia_token) },
        as: :json
      )
    end

    assert_response 204
  end

  test "should not destroy a non-existent report" do
    assert_no_changes('Report.count') do
      delete(
        report_url('docs.italia.it', 'no-such-key'),
        headers: { 'Authorization' => authorization(@docs_italia_token) },
        as: :json
      )
    end

    assert_response 404
    assert_equal({ 'error' => 'Report not found' }, response.parsed_body)
  end

  private
    def authorization(token)
      ActionController::HttpAuthentication::Token.encode_credentials(token)
    end
end
