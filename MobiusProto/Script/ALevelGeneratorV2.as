import AMobiusGameMode;

class ALevelGeneratorV2 : AActor 
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UBoxComponent BoxCollision;

    UPROPERTY()
    AMobiusGameMode GameMode;

    UPROPERTY(DefaultComponent, Attach = BoxCollision)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetWorldScale3D(FVector(400, 25, 1));
    default MeshComp.StaticMesh = Asset("/Engine/BasicShapes/Cube.Cube");
    default BoxCollision.SetBoxExtent(MeshComp.GetBoundingBoxExtents()); 

    UPROPERTY(DefaultComponent, Attach = BoxCollision)
    UStaticMeshComponent SpawnLoc;
    default SpawnLoc.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY()
    TArray<float> LocationPointX;
    UPROPERTY()
    TArray<float> LocationPointY;

    UPROPERTY(DefaultComponent, Attach = BoxCollision)
    UBoxComponent SpawnTriggerComp;
    default SpawnTriggerComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);
    default SpawnTriggerComp.SetCollisionEnabled(ECollisionEnabled::QueryAndPhysics);

    UPROPERTY()
    TSubclassOf<AActor> LevelGeneratorType;
    AActor LevelGenerator;

    UPROPERTY()
    TSubclassOf<AActor> PointRepresentType;
    AActor PointRepresent;

    UPROPERTY()
    TSubclassOf<AActor> ObstacleType;
    AActor Obstacle;

    UPROPERTY()
    float MovementSpeed = 3000; //AMobiusGameMode.GlobalMovementSpeed;

    float PointReferenceX;
    float PointReferenceY;

    UPROPERTY()
    int NumberOfSpawn;

    float XPositionMultiplier = 100;
    float YPositionMultiplier = 80;

    int XMaxCount;
    int XMinCount;
    int XTargetCount;
    int XCurrentSpawnCount;

    //Left to Right Rows
    UPROPERTY()
    TArray<float> ChosenYIndex;
    //Forward Rows
    UPROPERTY()
    TArray<float> ChosenXIndex;

    UFUNCTION(BlueprintOverride)
    void BeginPlay() 
    {
        Print("Level Generated", 5);

        XMaxCount = 15;
        XMinCount = 10;

        SpawnTriggerComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");

        GameMode = Cast<AMobiusGameMode>(Gameplay::GetGameMode());
        MovementSpeed = GameMode.GlobalMovementSpeed;

        ConstructObstaclePositions();
        GenerateObstacles();
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        MoveLevel(DeltaSeconds);
    }

    UFUNCTION()
    void MoveLevel(float DeltaSeconds)
    {   
        FVector CurrentLoc = GetActorLocation();
        FVector NextLoc = CurrentLoc += FVector(-MovementSpeed * DeltaSeconds, 0, 0);
        // Print("Level Loc is " + NextLoc, 5);
        SetActorLocation(NextLoc);
    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        // Print("Overlapping with: " + OtherActor.Name, 5);
        SpawnNextLevel();
        //GenerateObstacles();
    }

    
    UFUNCTION()
    void SpawnNextLevel() 
    {
        LevelGenerator = SpawnActor(LevelGeneratorType, SpawnLoc.GetWorldLocation()); 
    }

    UFUNCTION() 
    void ConstructObstaclePositions()
    {
        PointReferenceX = MeshComp.GetWorldScale().X / 16;
        PointReferenceY = MeshComp.GetWorldScale().Y / 6.25f;

        int AddAmountX = MeshComp.GetWorldScale().X / PointReferenceX;
        int AddAmountY = MeshComp.GetWorldScale().Y / PointReferenceY;

        float XPos = -AddAmountX * XPositionMultiplier;
        float YPos = -AddAmountY * YPositionMultiplier * 3.1f;

        if (GameMode.GameStarted)
        {
            XPos += MeshComp.GetWorldScale().X * 50;
        }

        if (!GameMode.GameStarted)
        {
            GameMode.GameStarted = true;
        }

        for (int i = 0; i < PointReferenceX; i++)
        {
            XPos += AddAmountX * XPositionMultiplier;
            LocationPointX.Add(XPos);
        }

        for (int i = 0; i < PointReferenceY; i++)
        {
            YPos += AddAmountY * XPositionMultiplier;
            LocationPointY.Add(YPos);
        }

    }

    UFUNCTION()
    void SelectSpawnLocations()
    {
        //TO FIX - ENSURE THAT ROWS CANNOT EXCEED ROW 24
        XTargetCount = FMath::RandRange(XMinCount, XMaxCount);
        
        int RowDivision = LocationPointX.Num() / XTargetCount;
        int RowChosenIndex = -1;
        int RowAfterRandomized = 0;
        // Print(" " + RowDivision, 5);

        for (int i = 0; i < XTargetCount; i++)
        {
            if (i <= LocationPointX.Num() - 1) 
            {
                if (i == RowAfterRandomized)
                {
                    RowChosenIndex += RowDivision;
                }
                else 
                {
                    int r = FMath::RandRange(0, 3);

                    if(r == 0)
                    {
                        RowChosenIndex += RowDivision;
                    }
                    else
                    {
                        RowChosenIndex += RowDivision + FMath::RandRange(-1, 1);
                        RowAfterRandomized = RowChosenIndex + 1;
                    }
                }
            
            ChosenXIndex.Add(RowChosenIndex);
            
            }
            else 
            {
                Print("We exceeded our row amount ", 5);
            }


        }

        int YPreviousLoc = 0;
        int YCurrentLoc = 0;

        // Print("ChosenXIndex is this large: " + ChosenXIndex.Num(), 10);

        for (int y = 0; y < ChosenXIndex.Num(); y++)
        {
            YCurrentLoc = FMath::RandRange(0, 3);

            if (YCurrentLoc == YPreviousLoc)
            {
                YCurrentLoc = FMath::RandRange(0, 3);
            }
            else 
            {
                YPreviousLoc = YCurrentLoc;
            }

            ChosenYIndex.Add(YCurrentLoc);
        }
    }

    UFUNCTION()
    void GenerateObstacles() 
    {

        SelectSpawnLocations();
        //Show spawn points

        for(int x = 0; x < LocationPointX.Num(); x++)
        {
            float XLocation = LocationPointX[x];

            for (int y = 0; y < LocationPointY.Num(); y++) 
            {
                PointRepresent = SpawnActor(PointRepresentType, FVector(XLocation, LocationPointY[y], 150));
            }

            NumberOfSpawn++;
        }

        for (int i = 0; i < ChosenXIndex.Num(); i++)
        {
            Obstacle = SpawnActor(ObstacleType, FVector(LocationPointX[ChosenXIndex[i]], LocationPointY[ChosenYIndex[i]] , 150));
        }

    }
}