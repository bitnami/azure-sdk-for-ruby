#-------------------------------------------------------------------------
# Copyright 2013 Microsoft Open Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#--------------------------------------------------------------------------
require 'test_helper'

describe Azure::CloudServiceManagement::Serialization do
  subject { Azure::CloudServiceManagement::Serialization }

  let(:cloud_services_from_xml) { Fixtures['list_cloud_services'] }

  describe '#cloud_services_from_xml' do

    it 'accepts an XML string' do
      subject.cloud_services_from_xml Nokogiri::XML(cloud_services_from_xml)
    end

    it 'returns an Array of CloudService instances' do
      results = subject.cloud_services_from_xml(
        Nokogiri::XML(cloud_services_from_xml)
      )
      results.must_be_kind_of Array
      results[0].must_be_kind_of(Azure::CloudServiceManagement::CloudService)
      results.count.must_equal 2
    end
  end

  describe '#cloud_services_to_xml' do
    let(:cloud_service_name) {'cloud-service'}

    it 'accepts an name and options hash' do
      subject.cloud_services_to_xml cloud_service_name
    end

    it 'serializes the argument to xml' do
      results = subject.cloud_services_to_xml(
        cloud_service_name, { location: 'West US' }
      )
      results.must_be_kind_of String
      doc = Nokogiri::XML results
      doc.css('ServiceName').text.must_equal cloud_service_name
      doc.css('Location').text.must_equal 'West US'
    end

    it 'uses affinity_group if provided' do
      results = subject.cloud_services_to_xml(
        cloud_service_name,
        { affinity_group_name: 'my-affinity-group', location: 'West US' }
      )
      results.must_be_kind_of String
      doc = Nokogiri::XML results
      doc.css('ServiceName').text.must_equal cloud_service_name
      doc.css('AffinityGroup').text.must_equal 'my-affinity-group'
    end

    it 'serializes the options hash to xml' do
      results = subject.cloud_services_to_xml(
        cloud_service_name,
        { location: 'East US' }
      )
      doc = Nokogiri::XML results
      doc.css('Location').text.must_equal 'East US'
      results.must_be_kind_of String
    end
  end
end