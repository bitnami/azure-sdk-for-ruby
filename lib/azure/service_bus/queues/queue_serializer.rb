#-------------------------------------------------------------------------
# Copyright 2012 Microsoft Corporation
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
require "nokogiri"

module Azure
  module ServiceBus
    module Queues
      class QueueSerializer
        attr_accessor :properties

        # NOTE: The order of these values is significant 
        PROPERTIES = [
          'DefaultMessageTimeToLive',
          'DuplicateDetectionHistoryTimeWindow',
          'EnableBatchedOperations',
          'EnableDeadLetteringOnMessageExpiration',
          'ExtensionData',
          'IsReadOnly',
          'LockDuration',
          'MaxDeliveryCount',
          'MaxSizeInMegabytes',
          'MessageCount',
          'Path',
          'RequiresDuplicateDetection',
          'RequiresSession',
          'SizeInBytes'
        ].freeze

        def initialize(properties={})
          @properties = properties
          yield self if block_given?
        end

        def to_xml
          doc = Nokogiri::XML::Builder.new do |xml|
            xml.entry(:xmlns => 'http://www.w3.org/2005/Atom') {
              xml.content(:type => 'application/xml') {
                xml.QueueDescription('xmlns' => 'http://schemas.microsoft.com/netservices/2010/10/servicebus/connect', 'xmlns:i' => 'http://www.w3.org/2001/XMLSchema-instance') {
                  PROPERTIES.each do |p|
                    unless @properties[p].nil?
                      xml.send(p, @properties[p].to_s)
                    end
                  end
                }
              }
            }
          end
          doc.to_xml
        end
      end
    end
  end
end