Facter.add("xcrun_sdk_path") do
  setcode do
    os = Facter.value('osfamily')
    case os
    when "Darwin"
      myname = Facter::Core::Execution.exec('/usr/bin/xcrun --show-sdk-path')
    end
    myname
  end
end
