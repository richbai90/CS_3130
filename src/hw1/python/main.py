import googlemaps, time, json



def get_places(location):
    maps = googlemaps.Client("AIzaSyD3-bzXQif7AHLTthj0nWt5gE-hQaGilMY") # secret api key will be disabled soon
    nearby = maps.places_nearby;
    results = []
    token = ""
    for i in range(25):
        if token == "":
            page = nearby(location=location, radius=8047, type="restaurant")
        else:
            page = nearby(location=location, radius=8047, type="restaurant", page_token=token)
        if "results" not in page:
            break
        results += page["results"]
        if "next_page_token" not in page:
            break
        token = page["next_page_token"]
        time.sleep(10)
    
    return results;

if(__name__ == "__main__"):


    slc_results = get_places("40.771428,-111.893880",)
    sandiego_results = get_places("32.715672,-117.161045")

    with open("slc_restaurants.json", "w") as file:
        file.writelines([json.dumps(slc_results), ""])

    with open("sd_restaurants.json", "w") as file:
        file.writelines([json.dumps(sandiego_results), ""])