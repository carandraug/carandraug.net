#!/usr/bin/env python3

## Copyright (C) 2021 David Miguel Susano Pinto <carandraug@gmail.com>
##
## This program is free software: you can redistribute it and/or
## modify it under the terms of the GNU Affero General Public License
## as published by the Free Software Foundation, either version 3 of
## the License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## Affero General Public License for more details.
##
## You should have received a copy of the GNU Affero General Public
## License along with this program.  If not, see
## <http://www.gnu.org/licenses/>.

from pelican import signals
from pelican.contents import Content
from pelican.urlwrappers import Tag


def add_category_tags(content: Content) -> None:
    if not hasattr(content, 'category'):
        return None

    if not hasattr(content, 'tags'):
        content.tags = []

    if content.category.name in content.settings['CATEGORY_TAGS']:
        category_tags = content.settings['CATEGORY_TAGS'][content.category]
        for new_tag in category_tags:
            if new_tag not in content.tags:
                content.tags.append(Tag(new_tag, content.settings))


def register():
    signals.content_object_init.connect(add_category_tags)
