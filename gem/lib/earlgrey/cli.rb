#
#  Copyright 2016 Google Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

module EarlGrey
  class CLI < Thor
    package_name 'EarlGrey'

    desc 'install', 'Installs EarlGrey into an Xcode unit test target'
    method_option :project, aliases: '-p', type: :string, required: false, desc: 'Project'
    method_option :target,  aliases: '-t', type: :string, required: true, desc: 'EarlGreyTestTarget'
    method_option :scheme,  aliases: '-s', type: :string, required: false, desc: 'EarlGreyTestTarget.xcscheme'
    method_option :swift,    type: :boolean, default: true
    method_option :carthage, type: :boolean, default: true

    PROJECT  = 'project'.freeze
    TARGET   = 'target'.freeze
    SCHEME   = 'scheme'.freeze
    SWIFT    = 'swift'.freeze
    CARTHAGE = 'carthage'.freeze

    def install
      o = options.dup

      # CLI will never use Cocoapod's `post_install do |installer|`
      podfile_installer = nil
      EarlGrey.swift    = o[SWIFT]
      EarlGrey.carthage = o[CARTHAGE]

      # Use target as the default Scheme name.
      o[SCHEME] ||= o[TARGET]

      o[PROJECT] ||= Dir.glob(File.join(Dir.pwd, '*.xcodeproj')).first
      raise 'No project found' unless o[PROJECT]

      EarlGrey.configure_for_earlgrey podfile_installer, o[PROJECT], o[TARGET], o[SCHEME]
    end
  end
end
