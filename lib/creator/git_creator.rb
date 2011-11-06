class GitCreator < SCMCreator

    class << self

        def url(name, regexp = %r{^(?:https?|git|ssh)://})
            super
        end

        def default_path(identifier)
            if options['git_ext']
                path(identifier) + '.git'
            else
                path(identifier)
            end
        end

        def repository_name_equal?(name, identifier)
            name == identifier || name == "#{identifier}.git"
        end

        def repository_exists?(identifier)
            path = path(identifier)
            File.directory?(path) || File.directory?("#{path}.git")
        end

        def create_repository(path)
            args = [ options['git'], 'init' ]
            append_options(args)
            args << path
            if system(*args)
                if options['update_server_info']
                    Dir.chdir(path) do
                        system(options['git'], 'update-server-info')
                    end
                end
                true
            else
                false
            end
        end

    end

end