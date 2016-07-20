#!/bin/sh

#  cleanFrameworks.sh
#  KemoCore
#
#  Created by Michal Racek on 20/07/16.
#  Copyright © 2016 PyJunkies. All rights reserved.

echo "Deleting libswift* libraries"
rm -f ${TARGET_BUILD_DIR}/KemoCore.framework/Versions/Current/Frameworks/libswift*
echo "Frameworks:"
ls ${TARGET_BUILD_DIR}/KemoCore.framework/Versions/Current/Frameworks

echo "Cleaning build scripts"
rm -rf ${TARGET_BUILD_DIR}/KemoCore.framework/Resources/BuildScripts
