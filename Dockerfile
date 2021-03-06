FROM microsoft/aspnetcore-build:2.0 AS build-env
WORKDIR /app
# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore
# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out -r linux-arm
# Build runtime image
FROM microsoft/dotnet:2.0.0-runtime-stretch-arm32v7
WORKDIR /app
COPY --from=build-env /app/out .
ENV ASPNETCORE_URLS http://+:80
EXPOSE 80
ENTRYPOINT ["dotnet", "netcoreapi.dll"]