
Pod::Spec.new do |spec|

  spec.name         = "MDSoftCalendar"
  spec.version      = "1.0.0"
  spec.summary      = "Easy clear Calendar."
  spec.description  = "aims to help produce an easily usable implementation of create beauty calendar."
  spec.homepage     = "https://github.com/maedilaziman"
  spec.license      = { :type => 'Apache License, Version 2.0', :text => '
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.' }

  spec.author             = { "Maedi Laziman" => "maedilaziman@gmail.com" }
  spec.platform     = :ios, "11.6"
  spec.source       = { :git => "https://github.com/maedilaziman/innosoft-mdcalendar.git", :tag => "#{spec.version}" }
  spec.swift_version = "5.1"
  spec.ios.deployment_target = '11.6'
  spec.source_files = "MDSoftCalendar/**/*.{swift,h,xib,png}"
  

end
