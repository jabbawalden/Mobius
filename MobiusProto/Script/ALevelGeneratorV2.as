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
    float MovementSpeed = 3000; //AMobiusGameMode.GlobalMovementSpeed;

    float PointReferenceX;
    float PointReferenceY;

    UPROPERTY()
    int NumberOfSpawn;

    float XPositionMultiplier = 100;
    float YPositionMultiplier = 80;

    int MaxSpawnCount = 60;
    int MinSpawnCount = 30;
    int TargetSpawnCount;
    int CurrentSpawnCount;

    UFUNCTION(BlueprintOverride)
    void BeginPlay() 
    {
        Print("Level Generated", 5);

        SpawnTriggerComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        ConstructObstaclePositions();
        SpawnObstacles();

        GameMode = Cast<AMobiusGameMode>(Gameplay::GetGameMode());
        MovementSpeed = GameMode.GlobalMovementSpeed;
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
        //SpawnObstacles();
        Print("Overlapping", 5);
    }

    
    UFUNCTION()
    void SpawnNextLevel() 
    {
        LevelGenerator = SpawnActor(LevelGeneratorType, SpawnLoc.GetWorldLocation()); 
        Print("Level Spawn Called", 5);
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
    void SpawnObstacles() 
    {
        TargetSpawnCount = FMath::RandRange(MinSpawnCount, MaxSpawnCount);
        
        Print("Target Spawn Count Is: " + TargetSpawnCount, 5);
        for(int x = 0; x < LocationPointX.Num(); x++)
        {
            float XLocation = LocationPointX[x];

            for (int y = 0; y < LocationPointY.Num(); y++) 
            {
                PointRepresent = SpawnActor(PointRepresentType, FVector(XLocation, LocationPointY[y], 150));
            }

            NumberOfSpawn++;
        }

    }
}