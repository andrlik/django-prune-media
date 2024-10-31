# conftest.py
#
# Copyright (c) 2024 Daniel Andrlik
# All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause

import subprocess
from io import BytesIO, StringIO

import pytest
from django.core.files.storage import default_storage

from tests.sample_app.models import Record


@pytest.fixture(autouse=True)
def use_test_media(request, settings):
    settings.MEDIA_ROOT = str(settings.ROOT_DIR / "testmedia")

    def remove_test_media():
        subprocess.run(["rm", "-rf", settings.MEDIA_ROOT], check=False)  # noqa: S603 S607

    request.addfinalizer(remove_test_media)


@pytest.fixture(autouse=True)
def enable_db_access_for_all_tests(db):
    pass


@pytest.fixture
def cover_art_bytes() -> bytes:
    with open("tests/data/example_cover_art.png", "rb") as f:
        img_bytes = f.read()
    return img_bytes


@pytest.fixture
def record_with_files(cover_art_bytes) -> Record:
    r = Record.objects.create(name="Johnny One")
    r.image.save(name="cover_art.png", content=BytesIO(cover_art_bytes), save=True)
    r.document.save(
        name="hidden_message.txt", content=StringIO(initial_value="This is a secret...")
    )
    r.save()
    directory = r.image.name.rsplit("/", maxsplit=1)[0]
    default_storage.save(f"{directory}/extra_art.png", content=BytesIO(cover_art_bytes))
    yield r
    r.delete()
