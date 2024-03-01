require 'rails_helper'
require 'aws-sdk-s3'

describe "S3 Integration" do
  before(:all) do
    # Initialize the S3 client with test credentials
    aws_credentials = Rails.application.credentials.aws

    @s3_client = Aws::S3::Client.new(
      region: 'us-east-2',
      access_key_id: aws_credentials[:access_key_id],
      secret_access_key: aws_credentials[:secret_access_key]
    )
  end

  it "adds an object to the S3 bucket" do
    # Perform the action that adds an object to your S3 bucket (e.g., upload a file)
    file_content = "Test content" # Sample content
    bucket_name = 'farmboardbucket'
    object_key = 'test_object.txt'

    @s3_client.put_object(
      body: file_content,
      bucket: bucket_name,
      key: object_key
    )

    # Check if the object exists in the S3 bucket
    resp = @s3_client.get_object(
      bucket: bucket_name,
      key: object_key
    )


    # Assert that the object was successfully added to the S3 bucket
    expect(resp.body.read).to eq(file_content)
  end
end