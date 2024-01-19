module Spring
  def self.with_unbundled_env
    Bundler.send(:with_env, unbundled_env) { yield }
  end

  def self.unbundled_env
    env = Bundler.original_env

    if env.key?("BUNDLER_ORIG_MANPATH")
      env["MANPATH"] = env["BUNDLER_ORIG_MANPATH"]
    end

    env.delete_if {|k, _| k[0, 7] == "BUNDLE_" }

    if env.key?("RUBYOPT")
      env["RUBYOPT"] = env["RUBYOPT"].sub "-rbundler/setup", ""
    end

    if env.key?("RUBYLIB")
      rubylib = env["RUBYLIB"].split(File::PATH_SEPARATOR)
      rubylib.delete(File.expand_path("..", __FILE__))
      env["RUBYLIB"] = rubylib.join(File::PATH_SEPARATOR)
    end

    env
  end
end
