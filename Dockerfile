FROM ubuntu:16.10

ENV ANDROID_HOME /opt/android-sdk-linux

RUN apt-get update -qq

RUN apt-get install -y openjdk-8-jdk wget expect

# ------------------------------------------------------
# --- Download Android SDK tools into $ANDROID_HOME

RUN cd /opt && wget -q https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz -O android-sdk.tgz
RUN cd /opt && tar -xvzf android-sdk.tgz
RUN cd /opt && rm -f android-sdk.tgz

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN echo y | android update sdk --no-ui --all --filter platform-tools | grep 'package installed'

RUN echo y | android update sdk --no-ui --all --filter android-25 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-24 | grep 'package installed'

# Please keep these in descending order!
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.2 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.1 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.0 | grep 'package installed'

#RUN echo y | android update sdk --no-ui --all --filter sys-img-x86_64-android-24 | grep 'package installed'
#RUN echo y | android update sdk --no-ui --all --filter sys-img-x86-android-24 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter sys-img-armeabi-v7a-android-24 | grep 'package installed'

# Extras
RUN echo y | android update sdk --no-ui --all --filter extra-android-m2repository | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter extra-google-m2repository | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter extra-google-google_play_services | grep 'package installed'

#Copy accepted android licenses
RUN mkdir -p "${ANDROID_HOME}/licenses"
RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "${ANDROID_HOME}/licenses/android-sdk-license"
RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "${ANDROID_HOME}/licenses/android-sdk-preview-license"
RUN echo -e "\nd975f751698a77b662f1254ddbeed3901e976f5a" > "${ANDROID_HOME}/licenses/intel-android-extra-license"

ENV PATH ${PATH}:/opt/tools

# Update SDK
RUN android update sdk --no-ui --obsolete --force

RUN apt-get clean

#RUN chown -R 1000:1000 $ANDROID_HOME
#VOLUME ["/opt/android-sdk-linux"]
