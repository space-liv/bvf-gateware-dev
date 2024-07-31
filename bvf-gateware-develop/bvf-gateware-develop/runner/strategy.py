import toml


class Strategy(object):
    def __init__(self, file):
        self.file = file

        self.data = self.__load()

    def __load(self):
        return toml.load(self.file)

    def get_project_name(self):
        return self.data["build"]["metadata"]["project_name"]

    def get_top_level_name(self):
        return self.data["build"]["metadata"]["top_level_name"]

    def get_version(self):
        if "design_version" in self.data["build"]["metadata"]:
            return self.data["build"]["metadata"]["design_version"]
        else:
            return None

    def get_locations(self):
        return self.data["build"]["locations"]

    def get_modules(self):
        return self.data["build"]["modules"]

    def get_hss(self):
        return self.data["hss"]

    def get_mss(self):
        return self.data["build"]["mss"]

    def get_packaging(self):
        return self.data["packaging"]
